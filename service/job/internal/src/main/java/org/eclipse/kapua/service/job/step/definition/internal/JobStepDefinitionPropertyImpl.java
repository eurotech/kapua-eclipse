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

import java.util.Optional;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;
import javax.persistence.Table;

import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;

/**
 * The {@link JobStepProperty} implementation for {@link JobStepDefinitionImpl}.
 *
 * @since 2.0.0
 */
@Entity(name = "JobStepDefinitionProperty")
@Table(name = "job_job_step_definition_properties")
public class JobStepDefinitionPropertyImpl {

    @EmbeddedId
    public JobStepDefinitionPropertyId id;

    @MapsId("stepDefinitionId")
    @JoinColumns({
            @JoinColumn(name = "step_definition_id", referencedColumnName = "id"),
    })
    @ManyToOne
    public JobStepDefinitionImpl jobStepDefinition;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "name", column = @Column(insertable = false, updatable = false))
    })
    private JobStepPropertyImpl jobStepProperty;

    /**
     * Constructor.
     *
     * @since 2.0.0
     */
    public JobStepDefinitionPropertyImpl() {
    }

    /**
     * Constructor.
     *
     * @param jobStepDefinition
     *         The {@link JobStepDefinition} owner of the {@link JobStepProperty}
     * @param jobStepProperty
     *         The {@link JobStepProperty}
     * @since 2.0.0
     */
    public JobStepDefinitionPropertyImpl(JobStepDefinition jobStepDefinition, JobStepProperty jobStepProperty) {
        setId(new JobStepDefinitionPropertyId(jobStepDefinition.getId(), jobStepProperty.getName()));
        setJobStepDefinition(jobStepDefinition);
        setJobStepProperty(jobStepProperty);
    }

    /**
     * Gets the {@link JobStepDefinitionPropertyId}
     *
     * @return The {@link JobStepDefinitionPropertyId}
     * @since 2.0.0
     */
    public JobStepDefinitionPropertyId getId() {
        return id;
    }

    /**
     * Sets the {@link JobStepDefinitionPropertyId}
     *
     * @param id
     *         The {@link JobStepDefinitionPropertyId}
     * @since 2.0.0
     */
    public void setId(JobStepDefinitionPropertyId id) {
        this.id = id;
    }

    /**
     * Gets the {@link JobStepDefinition}
     *
     * @return The {@link JobStepDefinition}
     * @since 2.0.0
     */
    public JobStepDefinition getJobStepDefinition() {
        return jobStepDefinition;
    }

    /**
     * Sets the {@link JobStepDefinition}
     *
     * @param jobStepDefinition
     *         the {@link JobStepDefinition}
     * @since 2.0.0
     */
    public void setJobStepDefinition(JobStepDefinition jobStepDefinition) {
        this.jobStepDefinition = JobStepDefinitionImpl.parse(jobStepDefinition);
    }

    /**
     * Gets the {@link JobStepProperty}
     *
     * @return The {@link JobStepProperty}
     * @since 2.0.0
     */
    public JobStepProperty getJobStepProperty() {
        return jobStepProperty;
    }

    /**
     * Sets the {@link JobStepProperty}
     *
     * @param jobStepProperty
     *         The {@link JobStepProperty}
     * @since 2.0.0
     */
    public void setJobStepProperty(JobStepProperty jobStepProperty) {
        this.jobStepProperty = Optional.ofNullable(jobStepProperty)
                .map(jsp -> jsp instanceof JobStepPropertyImpl ?
                        (JobStepPropertyImpl) jsp :
                        JobStepPropertyImpl.parse(jsp)
                ).orElse(null);
    }

    /**
     * Parses the given {@link JobStepDefinition} and the {@link JobStepProperty} into a {@link JobStepDefinitionPropertyImpl}.
     *
     * @param jobStepDefinition
     *         The {@link JobStepDefinition} to parse.
     * @param jobStepProperty
     *         The {@link JobStepProperty} to parse.
     * @return The parsed {@link JobStepDefinitionPropertyImpl}
     * @since 2.0.0
     */
    public static JobStepDefinitionPropertyImpl parse(JobStepDefinition jobStepDefinition, JobStepProperty jobStepProperty) {
        if (jobStepProperty == null) {
            return null;
        }
        if (jobStepProperty instanceof JobStepDefinitionPropertyImpl) {
            return (JobStepDefinitionPropertyImpl) jobStepProperty;
        }
        return new JobStepDefinitionPropertyImpl(jobStepDefinition, jobStepProperty);
    }
}
