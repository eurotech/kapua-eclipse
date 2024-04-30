/*******************************************************************************
 * Copyright (c) 2024, 2022 Eurotech and/or its affiliates and others
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.service.job.step.definition.internal;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;
import javax.persistence.EntityManager;

import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.commons.jpa.JpaAwareTxContext;
import org.eclipse.kapua.commons.security.KapuaSecurityUtils;
import org.eclipse.kapua.locator.initializers.KapuaInitializingMethod;
import org.eclipse.kapua.model.KapuaNamedEntity;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRepository;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;
import org.eclipse.kapua.storage.TxContext;
import org.eclipse.kapua.storage.TxManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JobStepDefinitionAligner {

    private final TxManager txManager;
    private final JobStepDefinitionRepository jobStepDefinitionRepository;
    private final Set<JobStepDefinition> knownJobStepDefinitions;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final Comparator<JobStepDefinition> jobStepDefinitionComparator;
    private final Comparator<JobStepProperty> jobStepPropertyComparator;

    @Inject
    public JobStepDefinitionAligner(@Named("jobTxManager") TxManager txManager,
            JobStepDefinitionRepository domainRepository,
            Set<JobStepDefinition> knownJobStepDefinitions) {
        this.txManager = txManager;
        this.jobStepDefinitionRepository = domainRepository;
        this.knownJobStepDefinitions = knownJobStepDefinitions;
        jobStepDefinitionComparator = Comparator
                .comparing((JobStepDefinition jsp) -> Optional.ofNullable(jsp.getScopeId()).map(KapuaId::getId).orElse(null), Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepDefinition::getName, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepDefinition::getDescription, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepDefinition::getStepType, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepDefinition::getReaderName, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepDefinition::getProcessorName, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepDefinition::getWriterName, Comparator.nullsFirst(Comparator.naturalOrder()));
        jobStepPropertyComparator = Comparator
                .comparing(JobStepProperty::getName, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getPropertyType, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getPropertyValue, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getExampleValue, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getRequired, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getSecret, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getMinLength, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getMaxLength, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getMinValue, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getMaxValue, Comparator.nullsFirst(Comparator.naturalOrder()))
                .thenComparing(JobStepProperty::getValidationRegex, Comparator.nullsFirst(Comparator.naturalOrder()));
    }

    @KapuaInitializingMethod(priority = 20)
    public void populate() {
        logger.info("JobStepDefinitions alignment commencing. Found {} JobStepDefinition declarations in wiring", knownJobStepDefinitions.size());
        Map<String, JobStepDefinition> knownJobStepDefinitionsByName = knownJobStepDefinitions
                .stream()
                .collect(Collectors.toMap(KapuaNamedEntity::getName, d -> d));
        List<String> declaredJobStepDefinitionsNotInDb = new ArrayList<>(knownJobStepDefinitionsByName.keySet());
        try {
            KapuaSecurityUtils.doPrivileged(() -> {
                txManager.execute(tx -> {
                    List<JobStepDefinitionImpl> dbJobStepDefinitionEntries = jobStepDefinitionRepository.query(tx, new JobStepDefinitionQueryImpl(null)).getItems()
                            .stream()
                            .map(i -> (JobStepDefinitionImpl) i)
                            .collect(Collectors.toList());
                    logger.info("Found {} JobStepDefinition declarations in database", dbJobStepDefinitionEntries.size());

                    for (JobStepDefinitionImpl dbJobStepDefinitionEntry : dbJobStepDefinitionEntries) {
                        if (!knownJobStepDefinitionsByName.containsKey(dbJobStepDefinitionEntry.getName())) {
                            // Leave it be. As we share the database with other components, it might have been created by such components and be hidden from us
                            logger.warn("JobStepDefinition '{}' is only present in the database but has no current declaration!", dbJobStepDefinitionEntry.getName());
                            continue;
                        }

                        // Good news, it's both declared in wiring and present in the db!
                        declaredJobStepDefinitionsNotInDb.remove(dbJobStepDefinitionEntry.getName());

                        // Trigger fetch of Actions collection from db, otherwise the toString would not show the details
                        dbJobStepDefinitionEntry.getStepProperties();

                        // Check alignment between known and DB JobStepProperty
                        JobStepDefinition wiredJobStepDefinition = knownJobStepDefinitionsByName.get(dbJobStepDefinitionEntry.getName());

                        if (jobStepDefinitionComparator.compare(dbJobStepDefinitionEntry, wiredJobStepDefinition) == 0) {
                            logger.info("JobStepDefinition '{}' basic properties are ok... proceeding matching JobStepProperties...", dbJobStepDefinitionEntry.getName());

                            if (jobStepDefinitionPropertiesAreEqual(dbJobStepDefinitionEntry, wiredJobStepDefinition)) {
                                //We are happy!
                                logger.info("JobStepDefinition '{}' is ok!", dbJobStepDefinitionEntry.getName());
                                continue;
                            }
                        }

                        logger.info("JobStepDefinition '{}' is not ok!", dbJobStepDefinitionEntry.getName());

                        // Align them!
                        alignJobStepDefinitions(tx, dbJobStepDefinitionEntry, wiredJobStepDefinition);
                    }

                    if (declaredJobStepDefinitionsNotInDb.isEmpty()) {
                        logger.info("All wired JobStepDefinition were already present in the database");
                    } else {
                        logger.info("There are {} wired JobStepDefinition not present on the database", declaredJobStepDefinitionsNotInDb.size());

                        for (String declaredJobStepDefinitionsNotInDbName : declaredJobStepDefinitionsNotInDb) {
                            logger.info("Creating new JobStepDefinition '{}'...", declaredJobStepDefinitionsNotInDbName);

                            JobStepDefinition declaredJobStepDefinitionNotInDb = knownJobStepDefinitionsByName.get(declaredJobStepDefinitionsNotInDbName);

                            JobStepDefinitionImpl newJobStepDefinition = new JobStepDefinitionImpl();
                            newJobStepDefinition.setScopeId(declaredJobStepDefinitionNotInDb.getScopeId());
                            newJobStepDefinition.setName(declaredJobStepDefinitionNotInDb.getName());
                            newJobStepDefinition.setDescription(declaredJobStepDefinitionNotInDb.getDescription());
                            newJobStepDefinition.setStepType(declaredJobStepDefinitionNotInDb.getStepType());
                            newJobStepDefinition.setReaderName(declaredJobStepDefinitionNotInDb.getReaderName());
                            newJobStepDefinition.setProcessorName(declaredJobStepDefinitionNotInDb.getProcessorName());
                            newJobStepDefinition.setWriterName(declaredJobStepDefinitionNotInDb.getWriterName());
                            newJobStepDefinition.setStepProperties(declaredJobStepDefinitionNotInDb.getStepProperties());

                            jobStepDefinitionRepository.create(tx, newJobStepDefinition);

                            logger.info("Creating new JobStepDefinition '{}'... DONE!", declaredJobStepDefinitionsNotInDbName);
                        }
                    }

                    logger.info("JobStepDefinition alignment complete!");
                    return null;
                });
            });
        } catch (KapuaException e) {
            throw new RuntimeException(e);
        }
    }

    private boolean jobStepDefinitionPropertiesAreEqual(JobStepDefinition dbJobStepDefinitionEntry, JobStepDefinition wiredJobStepDefinition) {
        for (JobStepProperty wiredJobStepDefinitionProperty : wiredJobStepDefinition.getStepProperties()) {
            JobStepProperty dbJobStepDefinitionProperty = dbJobStepDefinitionEntry.getStepProperty(wiredJobStepDefinitionProperty.getName());

            if (dbJobStepDefinitionProperty == null) {
                logger.warn("Wired JobStepProperty '{}' of JobStepDefinition '{}' is not aligned with the database one",
                        wiredJobStepDefinitionProperty.getName(),
                        wiredJobStepDefinitionProperty.getName());

                return false;
            }

            if (jobStepPropertyComparator.compare(dbJobStepDefinitionProperty, wiredJobStepDefinitionProperty) != 0) {
                logger.warn("Database JobStepProperty '{}' of JobStepDefinition '{}' is not aligned with the wired one",
                        dbJobStepDefinitionProperty.getName(),
                        dbJobStepDefinitionEntry.getName());

                return false;
            }
        }

        return true;
    }

    private void alignJobStepDefinitions(TxContext txContext, JobStepDefinitionImpl dbJobStepDefinition, JobStepDefinition wiredJobStepDefinition) throws KapuaException {
        logger.info("JobStepDefinition '{}' aligning...", dbJobStepDefinition.getName());

        dbJobStepDefinition.setScopeId(wiredJobStepDefinition.getScopeId());
        dbJobStepDefinition.setName(wiredJobStepDefinition.getName());
        dbJobStepDefinition.setDescription(wiredJobStepDefinition.getDescription());
        dbJobStepDefinition.setStepType(wiredJobStepDefinition.getStepType());
        dbJobStepDefinition.setReaderName(wiredJobStepDefinition.getReaderName());
        dbJobStepDefinition.setProcessorName(wiredJobStepDefinition.getProcessorName());
        dbJobStepDefinition.setWriterName(wiredJobStepDefinition.getWriterName());

        EntityManager entityManager = JpaAwareTxContext.extractEntityManager(txContext);

        Map<String, JobStepDefinitionPropertyImpl> dbPropertiesByName = dbJobStepDefinition.getStepPropertiesEntitites()
                .stream()
                .collect(Collectors.toMap(jsp -> jsp.getId().getName(), jsp -> jsp));

        for (JobStepProperty wiredJobStepProperty : wiredJobStepDefinition.getStepProperties()) {
            JobStepDefinitionPropertyImpl dbJobStepPropertyEntity = dbPropertiesByName.get(wiredJobStepProperty.getName());

            if (dbJobStepPropertyEntity == null) {
                JobStepDefinitionPropertyImpl dbMissingJobStepProperty =
                        new JobStepDefinitionPropertyImpl(dbJobStepDefinition.getId(), wiredJobStepProperty);
                entityManager.persist(dbMissingJobStepProperty);
            } else {
                dbJobStepPropertyEntity.getJobStepProperty().setPropertyType(wiredJobStepProperty.getPropertyType());
                dbJobStepPropertyEntity.getJobStepProperty().setPropertyValue(wiredJobStepProperty.getPropertyValue());
                dbJobStepPropertyEntity.getJobStepProperty().setRequired(wiredJobStepProperty.getRequired());
                dbJobStepPropertyEntity.getJobStepProperty().setSecret(wiredJobStepProperty.getSecret());
                dbJobStepPropertyEntity.getJobStepProperty().setExampleValue(wiredJobStepProperty.getExampleValue());
                dbJobStepPropertyEntity.getJobStepProperty().setMinLength(wiredJobStepProperty.getMinLength());
                dbJobStepPropertyEntity.getJobStepProperty().setMaxLength(wiredJobStepProperty.getMaxLength());
                dbJobStepPropertyEntity.getJobStepProperty().setMinValue(wiredJobStepProperty.getMinValue());
                dbJobStepPropertyEntity.getJobStepProperty().setMaxValue(wiredJobStepProperty.getMaxValue());
                dbJobStepPropertyEntity.getJobStepProperty().setValidationRegex(wiredJobStepProperty.getValidationRegex());

                entityManager.merge(dbJobStepPropertyEntity);
            }
        }

        logger.info("JobStepDefinition '{}' aligning... DONE!", dbJobStepDefinition.getName());

    }
}
