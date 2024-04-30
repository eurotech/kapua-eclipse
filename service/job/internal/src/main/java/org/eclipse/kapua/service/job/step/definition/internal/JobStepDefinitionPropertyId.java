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

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EmbeddedId;

import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;

/**
 * The {@link EmbeddedId} for {@link JobStepDefinitionPropertyImpl}.
 * <p>
 * It is composed by the {@link JobStepDefinition#getId()} and {@link JobStepProperty#getName()} which are unique.
 *
 * @since 2.0.0
 */
@Embeddable
public class JobStepDefinitionPropertyId implements Serializable {

    private static final long serialVersionUID = -6533866941432301617L;

    protected KapuaEid stepDefinitionId;

    @Basic
    @Column(name = "name", nullable = false, updatable = false)
    private String name;

    /**
     * Constructor.
     *
     * @since 2.0.0
     */
    public JobStepDefinitionPropertyId() {
    }

    /**
     * Constructor.
     *
     * @param stepDefinitionId
     *         The {@link JobStepDefinition#getId()} part
     * @param name
     *         The {@link JobStepProperty#getName()} part
     * @since 2.0.0
     */
    public JobStepDefinitionPropertyId(KapuaId stepDefinitionId, String name) {
        this.stepDefinitionId = KapuaEid.parseKapuaId(stepDefinitionId);
        this.name = name;
    }

    /**
     * Gets the {@link JobStepDefinition#getId()} part
     *
     * @return The {@link JobStepDefinition#getId()} part
     * @since 2.0.0
     */
    public KapuaEid getStepDefinitionId() {
        return stepDefinitionId;
    }

    /**
     * Sets the {@link JobStepDefinition#getId()} part
     *
     * @param stepDefinitionId
     *         The {@link JobStepDefinition#getId()} part
     * @since 2.0.0
     */
    public void setStepDefinitionId(KapuaEid stepDefinitionId) {
        this.stepDefinitionId = stepDefinitionId;
    }

    /**
     * Gets the {@link JobStepProperty#getName()} part
     *
     * @return The {@link JobStepProperty#getName()} part
     * @since 2.0.0
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the {@link JobStepProperty#getName()} part
     *
     * @param name
     *         The {@link JobStepProperty#getName()} part
     * @since 2.0.0
     */
    public void setName(String name) {
        this.name = name;
    }
}
