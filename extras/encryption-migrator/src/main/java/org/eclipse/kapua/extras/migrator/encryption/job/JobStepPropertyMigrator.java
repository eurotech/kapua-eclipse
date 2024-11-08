/*******************************************************************************
 * Copyright (c) 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.extras.migrator.encryption.job;

import org.eclipse.kapua.extras.migrator.encryption.utils.SecretAttributeMigratorModelUtils;
import org.eclipse.kapua.locator.KapuaLocator;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Transient;

@Embeddable
public class JobStepPropertyMigrator implements JobStepProperty {

    //TODO: FIXME: REMOVE: A service in a jpa class? Behaviour should not be part of a data class!
    @Transient
    private final SecretAttributeMigratorModelUtils secretAttributeMigratorModelUtils = KapuaLocator.getInstance().getComponent(SecretAttributeMigratorModelUtils.class);

    @Basic
    @Column(name = "name", nullable = false, updatable = false)
    private String name;

    @Basic
    @Column(name = "description", nullable = false, updatable = false)
    private String description;

    @Basic
    @Column(name = "property_type", nullable = false, updatable = false)
    private String propertyType;

    @Basic
    @Column(name = "property_value")
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

    public JobStepPropertyMigrator() {
    }

    private JobStepPropertyMigrator(JobStepProperty jobStepProperty) {
        setPropertyValue(jobStepProperty.getPropertyValue());
    }

    @Override
    public String getPropertyValue() {
        return secretAttributeMigratorModelUtils.read(propertyValue);
    }

    @Override
    public void setPropertyValue(String propertyValue) {
        this.propertyValue = secretAttributeMigratorModelUtils.write(propertyValue);
    }

    public static JobStepPropertyMigrator parse(JobStepProperty jobStepProperty) {
        return jobStepProperty != null ? (jobStepProperty instanceof JobStepPropertyMigrator ? (JobStepPropertyMigrator) jobStepProperty : new JobStepPropertyMigrator(jobStepProperty)) : null;
    }
    // Attributes below do not require migration

    @Override
    public String getName() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setName(String name) {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getDescription() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setDescription(String description) {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getPropertyType() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setPropertyType(String propertyType) {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getExampleValue() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setExampleValue(String exampleValue) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Boolean getRequired() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setRequired(Boolean required) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Boolean getSecret() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setSecret(Boolean se) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Integer getMinLength() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setMinLength(Integer minLength) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Integer getMaxLength() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setMaxLength(Integer maxLength) {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getMinValue() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setMinValue(String minValue) {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getMaxValue() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setMaxValue(String maxValue) {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getValidationRegex() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setValidationRegex(String validationRegex) {
        throw new UnsupportedOperationException();
    }
}
