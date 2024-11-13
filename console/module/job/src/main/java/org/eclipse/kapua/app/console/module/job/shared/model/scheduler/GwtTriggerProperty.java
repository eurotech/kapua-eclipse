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
package org.eclipse.kapua.app.console.module.job.shared.model.scheduler;

import org.eclipse.kapua.app.console.module.api.shared.model.KapuaBaseModel;

public class GwtTriggerProperty extends KapuaBaseModel {

    public GwtTriggerProperty() {
    }

    public GwtTriggerProperty(String name, String type, String value) {
        setPropertyName(name);
        setPropertyType(type);
        setPropertyValue(value);
    }

    public String getPropertyName() {
        return get("propertyName");
    }

    public void setPropertyName(String propertyName) {
        set("propertyName", propertyName);
    }

    public String getDescription() {
        return get("description");
    }

    public void setDescription(String description) {
        set("description", description);
    }

    public String getPropertyType() {
        return get("propertyType");
    }

    public void setPropertyType(String propertyType) {
        set("propertyType", propertyType);
    }

    public String getPropertyValue() {
        return get("propertyValue");
    }

    public void setPropertyValue(String propertyValue) {
        set("propertyValue", propertyValue);
    }

    public boolean isEnum() {
        return get("isEnum");
    }

    public void setEnum(boolean isEnum) {
        set("isEnum", isEnum);
    }

}
