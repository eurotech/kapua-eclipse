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

public class JobStepPropertyRecord implements JobStepProperty {

    private String name;

    private String description;
    private String propertyType;
    private String propertyValue;
    private String exampleValue;
    private Boolean required;
    private Boolean secret;
    private Integer minLength;
    private Integer maxLength;
    private String minValue;
    private String maxValue;
    private String validationRegex;

    public JobStepPropertyRecord(String name,
            String propertyType,
            String propertyValue,
            String exampleValue,
            Boolean required,
            Boolean secret,
            Integer minLength,
            Integer maxLength,
            String minValue,
            String maxValue,
            String validationRegex) {
        this.name = name;
        this.propertyType = propertyType;
        this.propertyValue = propertyValue;
        this.exampleValue = exampleValue;
        this.required = required;
        this.secret = secret;
        this.minLength = minLength;
        this.maxLength = maxLength;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.validationRegex = validationRegex;
    }

    /**
     * Constructor.
     *
     * @param name The {@link JobStepProperty#getName()}
     * @param description The {@link JobStepProperty#getDescription()}
     * @param propertyType The {@link JobStepProperty#getPropertyType()}
     * @param propertyValue The {@link JobStepProperty#getPropertyValue()}
     * @param exampleValue The {@link JobStepProperty#getExampleValue()}
     * @param required The {@link JobStepProperty#getRequired()}
     * @param secret The {@link JobStepProperty#getSecret()}
     * @param minLength The {@link JobStepProperty#getMinLength()}
     * @param maxLength The {@link JobStepProperty#getMaxLength()}
     * @param minValue The {@link JobStepProperty#getMinValue()}
     * @param maxValue The {@link JobStepProperty#getMaxValue()}
     * @param validationRegex The {@link JobStepProperty#getValidationRegex()}
     *
     * @since 6.1.0
     */
    public JobStepPropertyRecord(String name,
            String description,
            String propertyType,
            String propertyValue,
            String exampleValue,
            Boolean required,
            Boolean secret,
            Integer minLength,
            Integer maxLength,
            String minValue,
            String maxValue,
            String validationRegex) {
        this(name,
                propertyType,
                propertyValue,
                exampleValue,
                required,
                secret,
                minLength,
                maxLength,
                minValue,
                maxValue,
                validationRegex);

        this.description = description;
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
    public String getExampleValue() {
        return exampleValue;
    }

    @Override
    public void setExampleValue(String exampleValue) {
        this.exampleValue = exampleValue;
    }

    @Override
    public Boolean getRequired() {
        return required;
    }

    @Override
    public void setRequired(Boolean required) {
        this.required = required;
    }

    @Override
    public Boolean getSecret() {
        return secret;
    }

    @Override
    public void setSecret(Boolean secret) {
        this.secret = secret;
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
}
