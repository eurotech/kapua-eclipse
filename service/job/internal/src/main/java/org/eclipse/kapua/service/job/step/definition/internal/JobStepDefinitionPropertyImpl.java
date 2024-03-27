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

import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;
import javax.persistence.Table;

import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;

@Entity(name = "JobStepPropertyForAligner")
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
    private JobStepPropertyImpl jobStepProperty;

    public JobStepDefinitionPropertyImpl() {
    }

    public JobStepDefinitionPropertyImpl(KapuaId jobStepId, JobStepProperty jobStepProperty) {
        setId(new JobStepDefinitionPropertyId(jobStepId, jobStepProperty.getName()));
        setJobStepProperty(jobStepProperty);
    }

    public JobStepDefinitionPropertyId getId() {
        return id;
    }

    public void setId(JobStepDefinitionPropertyId id) {
        this.id = id;
    }

    public JobStepDefinitionImpl getJobStepDefinition() {
        return jobStepDefinition;
    }

    public void setJobStepDefinition(JobStepDefinitionImpl jobStepDefinition) {
        this.jobStepDefinition = jobStepDefinition;
    }

    public JobStepPropertyImpl getJobStepProperty() {
        return jobStepProperty;
    }

    public void setJobStepProperty(JobStepProperty jobStepProperty) {
        this.jobStepProperty = Optional.ofNullable(jobStepProperty).map(jsp -> jsp instanceof JobStepPropertyImpl
                ? (JobStepPropertyImpl) jsp
                : JobStepPropertyImpl.parse(jsp)).orElse(null);
    }

    public static JobStepDefinitionPropertyImpl parse(KapuaId jobStepId, JobStepProperty jobStepProperty) {
        return jobStepProperty != null ? (jobStepProperty instanceof JobStepDefinitionPropertyImpl
                ? (JobStepDefinitionPropertyImpl) jobStepProperty
                : new JobStepDefinitionPropertyImpl(jobStepId, jobStepProperty)) : null;
    }
}
