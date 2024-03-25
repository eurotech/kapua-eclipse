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

import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.commons.jpa.JpaAwareTxContext;
import org.eclipse.kapua.commons.security.KapuaSecurityUtils;
import org.eclipse.kapua.locator.initializers.KapuaInitializingMethod;
import org.eclipse.kapua.model.KapuaNamedEntity;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRepository;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;
import org.eclipse.kapua.storage.TxContext;
import org.eclipse.kapua.storage.TxManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;
import javax.inject.Named;
import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

public class JobStepDefinitionAligner {

    private final TxManager txManager;
    private final JobStepDefinitionRepository jobStepDefinitionRepository;
    private final Set<JobStepDefinition> knownJobStepDefinitions;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Inject
    public JobStepDefinitionAligner(@Named("jobTxManager") TxManager txManager,
            JobStepDefinitionRepository domainRepository,
            Set<JobStepDefinition> knownJobStepDefinitions) {
        this.txManager = txManager;
        this.jobStepDefinitionRepository = domainRepository;
        this.knownJobStepDefinitions = knownJobStepDefinitions;
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
                    List<JobStepDefinition> dbJobStepDefinitionEntries = jobStepDefinitionRepository.query(tx, new JobStepDefinitionQueryImpl(null)).getItems();
                    logger.info("Found {} JobStepDefinition declarations in database", dbJobStepDefinitionEntries.size());

                    for (JobStepDefinition dbJobStepDefinitionEntry : dbJobStepDefinitionEntries) {
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

                        if (Objects.equals(dbJobStepDefinitionEntry.getScopeId(), wiredJobStepDefinition.getScopeId()) &&
                                Objects.equals(dbJobStepDefinitionEntry.getName(), wiredJobStepDefinition.getName()) &&
                                Objects.equals(dbJobStepDefinitionEntry.getDescription(), wiredJobStepDefinition.getDescription()) &&
                                Objects.equals(dbJobStepDefinitionEntry.getStepType(), wiredJobStepDefinition.getStepType()) &&
                                Objects.equals(dbJobStepDefinitionEntry.getReaderName(), wiredJobStepDefinition.getReaderName()) &&
                                Objects.equals(dbJobStepDefinitionEntry.getProcessorName(), wiredJobStepDefinition.getProcessorName()) &&
                                Objects.equals(dbJobStepDefinitionEntry.getWriterName(), wiredJobStepDefinition.getWriterName())
                        ) {
                            logger.info("JobStepDefinition '{}' basic properties are ok... proceeding matching JobStepProperties...", dbJobStepDefinitionEntry.getName());

                            if (jobStepDefinitionsAreEquals(dbJobStepDefinitionEntry, wiredJobStepDefinition)) {
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

                            //                            jobStepDefinitionRepository.create(tx, knownJobStepDefinitionsByName.get(declaredJobStepDefinitionsNotInDbName));

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

    private boolean jobStepDefinitionsAreEquals(JobStepDefinition dbJobStepDefinitionEntry, JobStepDefinition wiredJobStepDefinition) {
        for (JobStepProperty wiredJobStepDefinitionProperty : wiredJobStepDefinition.getStepProperties()) {
            JobStepProperty dbJobStepDefinitionProperty = dbJobStepDefinitionEntry.getStepProperty(wiredJobStepDefinitionProperty.getName());

            if (dbJobStepDefinitionProperty == null) {
                logger.warn("Wired JobStepProperty '{}' of JobStepDefinition '{}' is not aligned with the database one",
                        wiredJobStepDefinitionProperty.getName(),
                        wiredJobStepDefinitionProperty.getName());

                return false;
            }

            if (!jobStepPropertiesAreEquals(dbJobStepDefinitionProperty, wiredJobStepDefinitionProperty)) {
                logger.warn("Database JobStepProperty '{}' of JobStepDefinition '{}' is not aligned with the wired one",
                        dbJobStepDefinitionProperty.getName(),
                        dbJobStepDefinitionEntry.getName());

                return false;
            }
        }

        return true;
    }

    private boolean jobStepPropertiesAreEquals(JobStepProperty dbJobStepDefinitionProperty, JobStepProperty wiredJobStepDefinitionProperty) {
        return (Objects.equals(dbJobStepDefinitionProperty.getName(), wiredJobStepDefinitionProperty.getName()) &&
                Objects.equals(dbJobStepDefinitionProperty.getPropertyType(), wiredJobStepDefinitionProperty.getPropertyType()) &&
                Objects.equals(dbJobStepDefinitionProperty.getPropertyValue(), wiredJobStepDefinitionProperty.getPropertyValue()) &&
                Objects.equals(dbJobStepDefinitionProperty.getExampleValue(), wiredJobStepDefinitionProperty.getExampleValue()) &&
                Objects.equals(dbJobStepDefinitionProperty.getRequired(), wiredJobStepDefinitionProperty.getRequired()) &&
                Objects.equals(dbJobStepDefinitionProperty.getSecret(), wiredJobStepDefinitionProperty.getSecret()) &&
                Objects.equals(dbJobStepDefinitionProperty.getMinLength(), wiredJobStepDefinitionProperty.getMinLength()) &&
                Objects.equals(dbJobStepDefinitionProperty.getMaxLength(), wiredJobStepDefinitionProperty.getMaxLength()) &&
                Objects.equals(dbJobStepDefinitionProperty.getMinValue(), wiredJobStepDefinitionProperty.getMinValue()) &&
                Objects.equals(dbJobStepDefinitionProperty.getMaxValue(), wiredJobStepDefinitionProperty.getMaxValue()) &&
                Objects.equals(dbJobStepDefinitionProperty.getValidationRegex(), wiredJobStepDefinitionProperty.getValidationRegex())
        );
    }

    //    private void createMissingDomains(TxContext tx, List<String> declaredDomainsNotInDb, Map<String, Domain> knownDomainsByName) throws KapuaException {
    //        if (declaredDomainsNotInDb.size() > 0) {
    //            logger.info("Found {} declared domains that have no counterpart in the database!", declaredDomainsNotInDb.size());
    //            //Create wired domains not present in the db
    //            for (final String declaredOnlyName : declaredDomainsNotInDb) {
    //                final Domain expected = knownDomainsByName.get(declaredOnlyName);
    //                createDomainInDb(tx, expected);
    //            }
    //        }
    //    }
    //
    //    private void createDomainInDb(TxContext tx, Domain expected) throws KapuaException {
    //        logger.info("To be added: {}", expected);
    //        final org.eclipse.kapua.service.authorization.domain.Domain newEntity = new DomainImpl();
    //        newEntity.setName(expected.getName());
    //        newEntity.setActions(expected.getActions());
    //        newEntity.setGroupable(expected.getGroupable());
    //        newEntity.setServiceName(expected.getServiceName());
    //        jobStepDefinitionRepository.create(tx, newEntity);
    //    }

    private void alignJobStepDefinitions(TxContext txContext, JobStepDefinition dbJobStepDefinition, JobStepDefinition wiredJobStepDefinition) throws KapuaException {
        logger.info("JobStepDefinition '{}' aligning...", dbJobStepDefinition.getName());

        dbJobStepDefinition.setScopeId(wiredJobStepDefinition.getScopeId());
        dbJobStepDefinition.setName(wiredJobStepDefinition.getName());
        dbJobStepDefinition.setDescription(wiredJobStepDefinition.getDescription());
        dbJobStepDefinition.setStepType(wiredJobStepDefinition.getStepType());
        dbJobStepDefinition.setReaderName(wiredJobStepDefinition.getReaderName());
        dbJobStepDefinition.setProcessorName(wiredJobStepDefinition.getProcessorName());
        dbJobStepDefinition.setWriterName(wiredJobStepDefinition.getWriterName());

        EntityManager entityManager = JpaAwareTxContext.extractEntityManager(txContext);

        for (JobStepProperty wiredJobStepProperty : wiredJobStepDefinition.getStepProperties()) {
            JobStepPropertyForAlignerId jobStepPropertyForAlignerId = new JobStepPropertyForAlignerId(dbJobStepDefinition.getId(), wiredJobStepProperty.getName());

            JobStepPropertyForAlignerImpl dbJobStepPropertyAligner = entityManager.find(JobStepPropertyForAlignerImpl.class, jobStepPropertyForAlignerId);

            if (dbJobStepPropertyAligner == null) {
                JobStepPropertyForAlignerImpl dbMissingJobStepProperty = JobStepPropertyForAlignerImpl.parse(wiredJobStepProperty);
                dbMissingJobStepProperty.setJobStepPropertyForAlignerId(jobStepPropertyForAlignerId);

                entityManager.persist(dbMissingJobStepProperty);
            } else {
                dbJobStepPropertyAligner.setPropertyType(wiredJobStepProperty.getPropertyType());
                dbJobStepPropertyAligner.setPropertyValue(wiredJobStepProperty.getPropertyValue());
                dbJobStepPropertyAligner.setRequired(wiredJobStepProperty.getRequired());
                dbJobStepPropertyAligner.setSecret(wiredJobStepProperty.getSecret());
                dbJobStepPropertyAligner.setExampleValue(wiredJobStepProperty.getExampleValue());
                dbJobStepPropertyAligner.setMinLength(wiredJobStepProperty.getMinLength());
                dbJobStepPropertyAligner.setMaxLength(wiredJobStepProperty.getMaxLength());
                dbJobStepPropertyAligner.setMinValue(wiredJobStepProperty.getMinValue());
                dbJobStepPropertyAligner.setMaxValue(wiredJobStepProperty.getMaxValue());
                dbJobStepPropertyAligner.setValidationRegex(wiredJobStepProperty.getValidationRegex());

                entityManager.merge(dbJobStepPropertyAligner);
            }
        }

        logger.info("JobStepDefinition '{}' aligning... DONE!", dbJobStepDefinition.getName());

    }
}
