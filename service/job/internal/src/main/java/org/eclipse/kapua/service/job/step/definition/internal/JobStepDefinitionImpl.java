/*******************************************************************************
 * Copyright (c) 2017, 2022 Eurotech and/or its affiliates and others
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
import org.eclipse.kapua.commons.model.AbstractKapuaNamedEntity;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;
import org.eclipse.kapua.service.job.step.definition.JobStepType;

import javax.persistence.Basic;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.List;

/**
 * {@link JobStepDefinition} implementation.
 *
 * @since 1.0.0
 */
@Entity(name = "JobStepDefinition")
@Table(name = "job_job_step_definition")
public class JobStepDefinitionImpl extends AbstractKapuaNamedEntity implements JobStepDefinition {

    private static final long serialVersionUID = 3747451706859757246L;

    @Enumerated(EnumType.STRING)
    @Column(name = "job_step_type", nullable = false, updatable = false)
    private JobStepType jobStepType;

    @Basic
    @Column(name = "reader_name", nullable = false, updatable = false)
    private String readerName;

    @Basic
    @Column(name = "processor_name", nullable = false, updatable = false)
    private String processorName;

    @Basic
    @Column(name = "writer_name", nullable = false, updatable = false)
    private String writerName;

    @ElementCollection
    @CollectionTable(name = "job_job_step_definition_properties", joinColumns = @JoinColumn(name = "step_definition_id", referencedColumnName = "id"))
    private List<JobStepPropertyImpl> jobStepProperties;

    /**
     * Constructor.
     *
     * @since 1.0.0
     */
    public JobStepDefinitionImpl() {
    }

    /**
     * Constructor.
     *
     * @param scopeId The scope {@link KapuaId} to set into the {@link JobStepDefinition}
     * @since 1.0.0
     */
    public JobStepDefinitionImpl(KapuaId scopeId) {
        super(scopeId);
    }

    /**
     * Clone constructor.
     *
     * @param jobStepDefinition
     * @throws KapuaException
     * @since 1.1.0
     */
    public JobStepDefinitionImpl(JobStepDefinition jobStepDefinition) throws KapuaException {
        super(jobStepDefinition);

        setStepType(jobStepDefinition.getStepType());
        setReaderName(jobStepDefinition.getReaderName());
        setProcessorName(jobStepDefinition.getProcessorName());
        setWriterName(jobStepDefinition.getWriterName());
        setStepProperties(jobStepDefinition.getStepProperties());
    }

    @Override
    public JobStepType getStepType() {
        return jobStepType;
    }

    @Override
    public void setStepType(JobStepType jobStepType) {
        this.jobStepType = jobStepType;

    }

    @Override
    public String getReaderName() {
        return readerName;
    }

    @Override
    public void setReaderName(String readerName) {
        this.readerName = readerName;
    }

    @Override
    public String getProcessorName() {
        return processorName;
    }

    @Override
    public void setProcessorName(String processorName) {
        this.processorName = processorName;
    }

    @Override
    public String getWriterName() {
        return writerName;
    }

    @Override
    public void setWriterName(String writesName) {
        this.writerName = writesName;
    }

    @Override
    public List<JobStepPropertyImpl> getStepProperties() {
        if (jobStepProperties == null) {
            jobStepProperties = new ArrayList<>();
        }

        return jobStepProperties;
    }

    @Override
    public JobStepProperty getStepProperty(String name) {
        return getStepProperties()
                .stream()
                .filter(jsp -> jsp.getName().equals(name))
                .findAny()
                .orElse(null);
    }

    @Override
    public void setStepProperties(List<JobStepProperty> jobStepProperties) {
        this.jobStepProperties = new ArrayList<>();

        for (JobStepProperty sp : jobStepProperties) {
            this.jobStepProperties.add(JobStepPropertyImpl.parse(sp));
        }

    }
}
