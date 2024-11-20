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


import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerDefinition;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerProperty;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;
import javax.persistence.Table;
import java.util.Optional;

/**
 * The {@link TriggerProperty} implementation for {@link TriggerDefinitionImpl}.
 *
 * @since 2.1.0
 */
@Entity(name = "TriggerDefinitionProperty")
@Table(name = "schdl_trigger_definition_properties")
public class TriggerDefinitionPropertyImpl {

    @EmbeddedId
    public TriggerDefinitionPropertyId id;

    @MapsId("triggerDefinitionId")
    @JoinColumns({
            @JoinColumn(name = "trigger_definition_id", referencedColumnName = "id"),
    })
    @ManyToOne
    public TriggerDefinitionImpl triggerDefinition;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "name", column = @Column(insertable = false, updatable = false))
    })
    private TriggerPropertyImpl triggerProperty;

    /**
     * Constructor.
     *
     * @since 2.1.0
     */
    public TriggerDefinitionPropertyImpl() {
    }

    /**
     * Constructor.
     *
     * @param triggerDefinition
     *         The {@link TriggerDefinition} owner of the {@link TriggerProperty}
     * @param triggerProperty
     *         The {@link TriggerProperty}
     * @since 2.1.0
     */
    public TriggerDefinitionPropertyImpl(TriggerDefinition triggerDefinition, TriggerProperty triggerProperty) {
        setId(new TriggerDefinitionPropertyId(triggerDefinition.getId(), triggerProperty.getName()));
        setTriggerDefinition(triggerDefinition);
        setTriggerProperty(triggerProperty);
    }

    /**
     * Gets the {@link TriggerDefinitionPropertyId}
     *
     * @return The {@link TriggerDefinitionPropertyId}
     * @since 2.0.0
     */
    public TriggerDefinitionPropertyId getId() {
        return id;
    }

    /**
     * Sets the {@link TriggerDefinitionPropertyId}
     *
     * @param id
     *         The {@link TriggerDefinitionPropertyId}
     * @since 2.0.0
     */
    public void setId(TriggerDefinitionPropertyId id) {
        this.id = id;
    }

    /**
     * Gets the {@link TriggerDefinition}
     *
     * @return The {@link TriggerDefinition}
     * @since 2.0.0
     */
    public TriggerDefinition getTriggerDefinition() {
        return triggerDefinition;
    }

    /**
     * Sets the {@link TriggerDefinition}
     *
     * @param triggerDefinition
     *         the {@link TriggerDefinition}
     * @since 2.0.0
     */
    public void setTriggerDefinition(TriggerDefinition triggerDefinition) {
        this.triggerDefinition = TriggerDefinitionImpl.parse(triggerDefinition);
    }

    /**
     * Gets the {@link TriggerProperty}
     *
     * @return The {@link TriggerProperty}
     * @since 2.0.0
     */
    public TriggerProperty getTriggerProperty() {
        return triggerProperty;
    }

    /**
     * Sets the {@link TriggerProperty}
     *
     * @param triggerProperty
     *         The {@link TriggerProperty}
     * @since 2.1.0
     */
    public void setTriggerProperty(TriggerProperty triggerProperty) {
        this.triggerProperty = Optional.ofNullable(triggerProperty)
                .map(jsp -> jsp instanceof TriggerPropertyImpl ?
                        (TriggerPropertyImpl) jsp :
                        TriggerPropertyImpl.parse(jsp)
                ).orElse(null);
    }

    /**
     * Parses the given {@link TriggerDefinition} and the {@link TriggerProperty} into a {@link TriggerDefinitionPropertyImpl}.
     *
     * @param triggerDefinition
     *         The {@link TriggerDefinition} to parse.
     * @param triggerProperty
     *         The {@link TriggerProperty} to parse.
     * @return The parsed {@link TriggerDefinitionPropertyImpl}
     * @since 2.1.0
     */
    public static TriggerDefinitionPropertyImpl parse(TriggerDefinition triggerDefinition, TriggerProperty triggerProperty) {
        if (triggerProperty == null) {
            return null;
        }
        if (triggerProperty instanceof TriggerDefinitionPropertyImpl) {
            return (TriggerDefinitionPropertyImpl) triggerProperty;
        }
        return new TriggerDefinitionPropertyImpl(triggerDefinition, triggerProperty);
    }
}
