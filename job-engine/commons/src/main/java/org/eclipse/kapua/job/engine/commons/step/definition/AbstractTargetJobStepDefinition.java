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
package org.eclipse.kapua.job.engine.commons.step.definition;

import org.eclipse.kapua.commons.model.AbstractKapuaNamedEntity;
import org.eclipse.kapua.job.engine.commons.operation.DefaultTargetReader;
import org.eclipse.kapua.job.engine.commons.operation.DefaultTargetWriter;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepType;

public abstract class AbstractTargetJobStepDefinition extends AbstractKapuaNamedEntity implements JobStepDefinition {

    private static final long serialVersionUID = 474195961081702478L;

    @Override
    public JobStepType getStepType() {
        return JobStepType.TARGET;
    }

    @Override
    public void setStepType(JobStepType jobStepType) {
    }

    @Override
    public String getReaderName() {
        return DefaultTargetReader.class.getName();
    }

    @Override
    public void setReaderName(String readerName) {
    }

    @Override
    public void setProcessorName(String processorName) {
    }

    @Override
    public String getWriterName() {
        return DefaultTargetWriter.class.getName();
    }

    @Override
    public void setWriterName(String writesName) {
    }

}
