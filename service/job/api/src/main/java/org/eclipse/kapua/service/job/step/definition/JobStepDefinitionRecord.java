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
package org.eclipse.kapua.service.job.step.definition;

import org.eclipse.kapua.entity.EntityPropertiesReadException;
import org.eclipse.kapua.entity.EntityPropertiesWriteException;
import org.eclipse.kapua.model.id.KapuaId;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

public abstract class JobStepDefinitionRecord implements JobStepDefinition {

    private static final long serialVersionUID = 8163044089055983759L;
    private KapuaId scopeId;
    private String name;
    private String description;
    private JobStepType stepType;
    private String readerName;
    private String processorName;
    private String writerName;
    private List<JobStepProperty> jobStepProperties;

    public JobStepDefinitionRecord(KapuaId scopeId,
            String name,
            String description,
            JobStepType stepType,
            String readerName,
            String processorName,
            String writerName,
            List<JobStepProperty> jobStepProperties) {
        this.scopeId = scopeId;
        this.name = name;
        this.description = description;
        this.stepType = stepType;
        this.readerName = readerName;
        this.processorName = processorName;
        this.writerName = writerName;
        this.jobStepProperties = jobStepProperties;
    }

    @Override
    public KapuaId getScopeId() {
        return scopeId;
    }

    @Override
    public void setScopeId(KapuaId scopeId) {
        this.scopeId = scopeId;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public JobStepType getStepType() {
        return stepType;
    }

    @Override
    public void setStepType(JobStepType stepType) {
        this.stepType = stepType;
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
    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }

    @Override
    public <P extends JobStepProperty> List<P> getStepProperties() {
        return (List<P>) jobStepProperties;
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
        this.jobStepProperties = new ArrayList<>(jobStepProperties);
    }

    @Override
    public KapuaId getId() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setId(KapuaId id) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Date getCreatedOn() {
        throw new UnsupportedOperationException();
    }

    @Override
    public KapuaId getCreatedBy() {
        throw new UnsupportedOperationException();
    }

    @Override
    public Date getModifiedOn() {
        throw new UnsupportedOperationException();
    }

    @Override
    public KapuaId getModifiedBy() {
        throw new UnsupportedOperationException();
    }

    @Override
    public int getOptlock() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setOptlock(int optlock) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Properties getEntityAttributes() throws EntityPropertiesReadException {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setEntityAttributes(Properties props) throws EntityPropertiesWriteException {
        throw new UnsupportedOperationException();
    }

    @Override
    public Properties getEntityProperties() throws EntityPropertiesReadException {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setEntityProperties(Properties props) throws EntityPropertiesWriteException {
        throw new UnsupportedOperationException();
    }

}
