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

import org.eclipse.kapua.commons.jpa.SecretAttributeConverter;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Embeddable;

@Embeddable
public class JobStepPropertyImpl implements JobStepProperty {

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
    @Column(name = "property_value", nullable = false, updatable = true)
    @Convert(converter = SecretAttributeConverter.class)
    private String propertyValue;

    @Basic
    @Column(name = "required", nullable = true, updatable = true)
    private Boolean required;

    @Basic
    @Column(name = "secret", nullable = true, updatable = true)
    private Boolean secret;

    @Basic
    @Column(name = "example_value", nullable = true, updatable = true)
    private String propertyExampleValue;

    @Basic
    @Column(name = "min_length", nullable = true, updatable = true)
    private Integer minLength;

    @Basic
    @Column(name = "max_length", nullable = true, updatable = true)
    private Integer maxLength;

    @Basic
    @Column(name = "min_value", nullable = true, updatable = true)
    private String minValue;

    @Basic
    @Column(name = "max_value", nullable = true, updatable = true)
    private String maxValue;

    @Basic
    @Column(name = "validation_regex", nullable = true, updatable = true)
    private String validationRegex;

    public JobStepPropertyImpl() {
    }

    private JobStepPropertyImpl(JobStepProperty jobStepProperty) {
        setName(jobStepProperty.getName());
        setDescription(jobStepProperty.getDescription());
        setPropertyType(jobStepProperty.getPropertyType());
        setPropertyValue(jobStepProperty.getPropertyValue());
        setRequired(jobStepProperty.getRequired());
        setSecret(jobStepProperty.getSecret());
        setExampleValue(jobStepProperty.getExampleValue());
        setMinLength(jobStepProperty.getMinLength());
        setMaxLength(jobStepProperty.getMaxLength());
        setMinValue(jobStepProperty.getMinValue());
        setMaxValue(jobStepProperty.getMaxValue());
        setValidationRegex(jobStepProperty.getValidationRegex());
    }

    public JobStepPropertyImpl(String name, String propertyType, String propertyValue, String propertyExampleValue) {
        setName(name);
        setPropertyType(propertyType);
        setPropertyValue(propertyValue);
        setExampleValue(propertyExampleValue);
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

    @Override
    public Boolean getRequired() {
        return required != null ? required : (propertyValue == null);
    }

    @Override
    public void setRequired(Boolean required) {
        this.required = required;
    }

    @Override
    public Boolean getSecret() {
        if (secret == null) {
            secret = Boolean.FALSE;
        }

        return secret;
    }

    @Override
    public void setSecret(Boolean secret) {
        this.secret = secret;
    }

    @Override
    public String getExampleValue() {
        return propertyExampleValue;
    }

    @Override
    public void setExampleValue(String exampleValue) {
        this.propertyExampleValue = exampleValue;
    }

    @Override
    public Integer getMinLength() {
        return minLength;
    }

    @Override
    public void setMinLength(Integer minLength) {
        this.minLength = minLength;
    }

    @Override
    public Integer getMaxLength() {
        return maxLength;
    }

    @Override
    public void setMaxLength(Integer maxLength) {
        this.maxLength = maxLength;
    }

    @Override
    public String getMinValue() {
        return minValue;
    }

    @Override
    public void setMinValue(String minValue) {
        this.minValue = minValue;
    }

    @Override
    public String getMaxValue() {
        return maxValue;
    }

    @Override
    public void setMaxValue(String maxValue) {
        this.maxValue = maxValue;
    }

    @Override
    public String getValidationRegex() {
        return validationRegex;
    }

    @Override
    public void setValidationRegex(String validationRegex) {
        this.validationRegex = validationRegex;
    }

    public static JobStepPropertyImpl parse(JobStepProperty jobStepProperty) {
        return jobStepProperty != null ? (jobStepProperty instanceof JobStepPropertyImpl ? (JobStepPropertyImpl) jobStepProperty : new JobStepPropertyImpl(jobStepProperty)) : null;
    }
}
