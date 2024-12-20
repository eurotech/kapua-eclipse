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
package org.eclipse.kapua.job.engine.commons.wrappers;

import com.google.common.base.Strings;
import org.eclipse.kapua.KapuaIllegalArgumentException;
import org.eclipse.kapua.KapuaRuntimeException;
import org.eclipse.kapua.commons.util.xml.XmlUtil;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.model.id.KapuaIdFactory;

import javax.batch.runtime.BatchStatus;
import javax.batch.runtime.Metric;
import javax.batch.runtime.context.StepContext;
import javax.xml.bind.DatatypeConverter;
import java.io.Serializable;
import java.util.Properties;

/**
 * {@link StepContextWrapper} wraps the {@link StepContext} and offers utility methods around it.
 *
 * @since 1.0.0
 */
public class StepContextWrapper {

    private final KapuaIdFactory kapuaIdFactory;

    private StepContext stepContext;

    public StepContextWrapper(KapuaIdFactory kapuaIdFactory, StepContext stepContext) {
        this.kapuaIdFactory = kapuaIdFactory;
        this.stepContext = stepContext;
    }

    public int getStepIndex() {
        Properties stepContextProperties = stepContext.getProperties();
        String stepIndexString = stepContextProperties.getProperty(StepContextPropertyNames.STEP_INDEX);

        if (Strings.isNullOrEmpty(stepIndexString)) {
            throw KapuaRuntimeException.internalError("stepIndexString is not available in the StepContext.properties");
        }

        return Integer.parseInt(stepIndexString);
    }

    public Integer getNextStepIndex() {
        Properties jobContextProperties = stepContext.getProperties();
        String stepNextIndexString = jobContextProperties.getProperty(StepContextPropertyNames.STEP_NEXT_INDEX);
        return stepNextIndexString != null ? Integer.parseInt(stepNextIndexString) : null;
    }

    public <T, E extends Enum<E>> T getStepProperty(String stepPropertyName, Class<T> type) throws KapuaIllegalArgumentException {
        Properties jobContextProperties = stepContext.getProperties();
        String stepPropertyString = jobContextProperties.getProperty(stepPropertyName);

        T stepProperty;
        if (stepPropertyString != null) {
            if (type == String.class) {
                stepProperty = (T) stepPropertyString;
            } else if (type == Integer.class) {
                stepProperty = (T) Integer.valueOf(stepPropertyString);
            } else if (type == Long.class) {
                stepProperty = (T) Long.valueOf(stepPropertyString);
            } else if (type == Float.class) {
                stepProperty = (T) Float.valueOf(stepPropertyString);
            } else if (type == Double.class) {
                stepProperty = (T) Double.valueOf(stepPropertyString);
            } else if (type == Boolean.class) {
                stepProperty = (T) Boolean.valueOf(stepPropertyString);
            } else if (type == byte[].class || type == Byte[].class) {
                stepProperty = (T) DatatypeConverter.parseBase64Binary(stepPropertyString);
            } else if (type == KapuaId.class || KapuaId.class.isAssignableFrom(type)) {
                stepProperty = (T) kapuaIdFactory.newKapuaId(stepPropertyString);
            } else if (type.isEnum()) {
                Class<E> enumType = (Class<E>) type;

                try {
                    stepProperty = (T) Enum.valueOf(enumType, stepPropertyString);
                } catch (IllegalArgumentException iae) {
                    throw new KapuaIllegalArgumentException(stepPropertyName, stepPropertyString);
                }
            } else {
                // Try both formats: XML - JSON
                try {
                    stepProperty = XmlUtil.unmarshal(stepPropertyString, type);
                } catch (Exception eXml) {
                    try {
                        stepProperty = XmlUtil.unmarshalJson(stepPropertyString, type);
                    } catch (Exception eJson) {
                        throw new KapuaIllegalArgumentException(stepPropertyName, stepPropertyString);
                    }
                }
            }
        } else {
            stepProperty = null;
        }

        return stepProperty;
    }

    public String getStepName() {
        return stepContext.getStepName();
    }

    public Object getTransientUserData() {
        return stepContext.getTransientUserData();
    }

    public void setTransientUserData(Object data) {
        stepContext.setTransientUserData(data);
    }

    public long getStepExecutionId() {
        return stepContext.getStepExecutionId();
    }

    public Properties getProperties() {
        return stepContext.getProperties();
    }

    public Serializable getPersistentUserData() {
        return stepContext.getPersistentUserData();
    }

    public void setPersistentUserData(Serializable data) {
        stepContext.setPersistentUserData(data);
    }

    public BatchStatus getBatchStatus() {
        return stepContext.getBatchStatus();
    }

    public String getExitStatus() {
        return stepContext.getExitStatus();
    }

    public void setExitStatus(String status) {
        stepContext.setExitStatus(status);
    }

    public Exception getException() {
        return stepContext.getException();
    }

    public Metric[] getMetrics() {
        return stepContext.getMetrics();
    }

    public String getKapuaStepName() {
        Properties stepContextProperties = stepContext.getProperties();
        String stepName = stepContextProperties.getProperty(StepContextPropertyNames.STEP_NAME);
        if (Strings.isNullOrEmpty(stepName)) {
            throw KapuaRuntimeException.internalError("stepName is not available in the StepContext.properties");
        }
        return stepName;
    }
}
