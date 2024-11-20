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

import org.eclipse.kapua.commons.model.AbstractKapuaEntity;
import org.eclipse.kapua.commons.model.AbstractKapuaNamedEntity;
import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerDefinition;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerProperty;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerType;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * {@link TriggerDefinition} implementation.
 *
 * @since 1.1.0
 */
@Entity(name = "TriggerDefinition")
@Table(name = "schdl_trigger_definition")
public class TriggerDefinitionImpl extends AbstractKapuaNamedEntity implements TriggerDefinition {

    private static final long serialVersionUID = 3747451706859757246L;


    /**
     * This overrides the {@link AbstractKapuaEntity#scopeId} JPA mapping which prevents the field to be updated. The {@link TriggerDefinitionAligner} may require to change the
     * {@link TriggerDefinition#getScopeId()}.
     *
     * @since 2.0.0
     */
    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "eid", column = @Column(name = "scope_id", nullable = true, updatable = true))
    })
    protected KapuaEid scopeId;

    @Enumerated(EnumType.STRING)
    @Column(name = "trigger_type", nullable = false, updatable = true)
    private TriggerType triggerType;

    @Basic
    @Column(name = "processor_name", nullable = false, updatable = true)
    private String processorName;

    @OneToMany(mappedBy = "triggerDefinition", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TriggerDefinitionPropertyImpl> triggerProperties;

    /**
     * Constructor.
     *
     * @since 1.1.0
     */
    public TriggerDefinitionImpl() {
    }

    /**
     * Constructor.
     *
     * @param scopeId The scope {@link KapuaId} to set into the {@link TriggerDefinition}
     * @since 1.1.0
     */
    public TriggerDefinitionImpl(KapuaId scopeId) {
        super(scopeId);
    }

    /**
     * Clone constructor.
     *
     * @param triggerDefinition The {@link TriggerDefinition} to clone
     * @since 1.1.0
     */
    public TriggerDefinitionImpl(TriggerDefinition triggerDefinition) {
        super(triggerDefinition);

        setTriggerType(triggerDefinition.getTriggerType());
        setProcessorName(triggerDefinition.getProcessorName());
        setTriggerProperties(triggerDefinition.getTriggerProperties());
    }

    /**
     * Gets the {@link TriggerDefinitionImpl#scopeId} instead of the {@link AbstractKapuaEntity#scopeId}.
     *
     * @return The {@link TriggerDefinitionImpl#scopeId}
     * @see #scopeId
     * @since 2.1.0
     */
    @Override
    public KapuaEid getScopeId() {
        return scopeId;
    }

    /**
     * Sets the {@link TriggerDefinitionImpl#scopeId} instead of the {@link AbstractKapuaEntity#scopeId}.
     *
     * @param scopeId
     *         The {@link TriggerDefinitionImpl#scopeId}
     * @see #scopeId
     * @since 2.1.0
     */
    @Override
    public void setScopeId(KapuaId scopeId) {
        this.scopeId = KapuaEid.parseKapuaId(scopeId);
    }

    @Override
    public TriggerType getTriggerType() {
        return triggerType;
    }

    @Override
    public void setTriggerType(TriggerType triggerType) {
        this.triggerType = triggerType;

    }

    @Override
    public String getProcessorName() {
        return processorName;
    }

    @Override
    public void setProcessorName(String processorName) {
        this.processorName = processorName;
    }

    @Override
    public List<TriggerProperty> getTriggerProperties() {
        if (triggerProperties == null) {
            triggerProperties = new ArrayList<>();
        }

        return triggerProperties.stream()
                .map(TriggerDefinitionPropertyImpl::getTriggerProperty)
                .collect(Collectors.toList());
    }

    @Override
    public TriggerProperty getTriggerProperty(String name) {
        return Optional.ofNullable(getTriggerProperties())
                .flatMap(triggerProperties -> triggerProperties
                        .stream()
                        .filter(triggerProperty -> triggerProperty.getName().equals(name))
                        .findAny())
                .orElse(null);
    }

    @Override
    public void setTriggerProperties(List<TriggerProperty> triggerProperties) {
        this.triggerProperties = new ArrayList<>();

        for (TriggerProperty triggerProperty : triggerProperties) {
            this.triggerProperties.add(TriggerDefinitionPropertyImpl.parse(this, triggerProperty));
        }
    }

    /**
     * Gets the reference to the JPA-mapped {@link List} of {@link TriggerDefinitionPropertyImpl}.
     *
     * @return The reference to the JPA-mapped {@link List} of {@link TriggerDefinitionPropertyImpl}.
     * @since 2.1.0
     */
    public List<TriggerDefinitionPropertyImpl> getTriggerPropertiesEntities() {
        return triggerProperties;
    }

    /**
     * Parses the given {@link TriggerDefinition} into a {@link TriggerDefinitionImpl}.
     *
     * @param triggerDefinition
     *         The {@link TriggerDefinition} to parse.
     * @return The parsed {@link TriggerDefinitionImpl}.
     * @since 2.1.0
     */
    public static TriggerDefinitionImpl parse(TriggerDefinition triggerDefinition) {
        return triggerDefinition != null ?
                (triggerDefinition instanceof TriggerDefinitionImpl ?
                        (TriggerDefinitionImpl) triggerDefinition :
                        new TriggerDefinitionImpl(triggerDefinition))
                : null;
    }
}
