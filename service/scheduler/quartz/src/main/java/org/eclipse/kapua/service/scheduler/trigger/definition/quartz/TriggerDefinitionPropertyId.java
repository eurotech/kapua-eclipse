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
package org.eclipse.kapua.service.scheduler.trigger.definition.quartz;

import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerDefinition;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerProperty;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EmbeddedId;
import java.io.Serializable;

/**
 * The {@link EmbeddedId} for {@link TriggerDefinitionPropertyImpl}.
 * <p>
 * It is composed by the {@link TriggerDefinition#getId()} and {@link TriggerProperty#getName()} which are unique.
 *
 * @since 2.0.0
 */
@Embeddable
public class TriggerDefinitionPropertyId implements Serializable {

    private static final long serialVersionUID = -6533866941432301617L;

    protected KapuaEid triggerDefinitionId;

    @Basic
    @Column(name = "name", nullable = false, updatable = false)
    private String name;

    /**
     * Constructor.
     *
     * @since 2.1.0
     */
    public TriggerDefinitionPropertyId() {
    }

    /**
     * Constructor.
     *
     * @param triggerDefinitionId
     *         The {@link TriggerDefinition#getId()} part
     * @param name
     *         The {@link TriggerProperty#getName()} part
     * @since 2.1.0
     */
    public TriggerDefinitionPropertyId(KapuaId triggerDefinitionId, String name) {
        this.triggerDefinitionId = KapuaEid.parseKapuaId(triggerDefinitionId);
        this.name = name;
    }

    /**
     * Gets the {@link TriggerDefinition#getId()} part
     *
     * @return The {@link TriggerDefinition#getId()} part
     * @since 2.1.0
     */
    public KapuaEid getTriggerDefinitionId() {
        return triggerDefinitionId;
    }

    /**
     * Sets the {@link TriggerDefinition#getId()} part
     *
     * @param triggerDefinitionId
     *         The {@link TriggerDefinition#getId()} part
     * @since 2.1.0
     */
    public void setTriggerDefinitionId(KapuaEid triggerDefinitionId) {
        this.triggerDefinitionId = triggerDefinitionId;
    }

    /**
     * Gets the {@link TriggerProperty#getName()} part
     *
     * @return The {@link TriggerProperty#getName()} part
     * @since 2.1.0
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the {@link TriggerProperty#getName()} part
     *
     * @param name
     *         The {@link TriggerProperty#getName()} part
     * @since 2.1.0
     */
    public void setName(String name) {
        this.name = name;
    }
}
