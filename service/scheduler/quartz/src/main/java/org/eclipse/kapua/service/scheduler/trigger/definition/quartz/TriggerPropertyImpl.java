/*******************************************************************************
 * Copyright (c) 2019, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.scheduler.trigger.definition.quartz;


import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerProperty;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * {@link TriggerProperty} implementation.
 *
 * @since 1.0.0
 */
@Embeddable
public class TriggerPropertyImpl implements TriggerProperty {

    @Basic
    @Column(name = "name", nullable = false, updatable = false)
    private String name;

    @Basic
    @Column(name = "description", nullable = false, updatable = true)
    private String description;

    @Basic
    @Column(name = "property_type", nullable = false, updatable = false)
    private String propertyType;

    @Basic
    @Column(name = "property_value", nullable = false, updatable = false)
    private String propertyValue;

    /**
     * Constructor
     *
     * @since 1.0.0
     */
    public TriggerPropertyImpl() {
    }

    /**
     * Clone constructor.
     *
     * @param triggerProperty The {@link TriggerProperty} to clone.
     * @since 1.1.0
     */
    private TriggerPropertyImpl(TriggerProperty triggerProperty) {
        setName(triggerProperty.getName());
        setDescription(triggerProperty.getDescription());
        setPropertyType(triggerProperty.getPropertyType());
        setPropertyValue(triggerProperty.getPropertyValue());
    }

    /**
     * Constructor.
     *
     * @param name          The name.
     * @param propertyType  The property type.
     * @param propertyValue The property value.
     * @since 1.0.0
     */
    public TriggerPropertyImpl(String name, String propertyType, String propertyValue) {
        setName(name);
        setPropertyType(propertyType);
        setPropertyValue(propertyValue);
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
    public String getPropertyType() {
        return propertyType;
    }

    @Override
    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    @Override
    public String getPropertyValue() {
        return propertyValue;
    }

    @Override
    public void setPropertyValue(String propertyValue) {
        this.propertyValue = propertyValue;
    }

    public static TriggerPropertyImpl parse(TriggerProperty triggerProperty) {
        return triggerProperty != null ? (triggerProperty instanceof TriggerPropertyImpl ? (TriggerPropertyImpl) triggerProperty : new TriggerPropertyImpl(triggerProperty)) : null;
    }
}
