/*******************************************************************************
 * Copyright (c) 2016, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.commons.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.eclipse.kapua.commons.model.id.IdGenerator;
import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.commons.security.KapuaSecurityUtils;
import org.eclipse.kapua.model.KapuaEntity;
import org.eclipse.kapua.model.KapuaUpdatableEntity;
import org.eclipse.kapua.model.id.KapuaId;

/**
 * {@link KapuaEntity} {@code abstract} implementation.
 *
 * @see KapuaEntity
 * @since 1.0.0
 */
@MappedSuperclass
@Access(AccessType.FIELD)
public abstract class AbstractKapuaEntity implements KapuaEntity, Serializable {

    private static final long serialVersionUID = -4118374896320453309L;
    @EmbeddedId
    @AttributeOverrides({
            @AttributeOverride(name = "eid", column = @Column(name = "id", nullable = false, updatable = false))
    })
    protected KapuaEid id;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "eid", column = @Column(name = "scope_id", nullable = true, updatable = false))
    })
    protected KapuaEid scopeId;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_on", nullable = false, updatable = false)
    protected Date createdOn;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "eid", column = @Column(name = "created_by", nullable = false, updatable = false))
    })
    protected KapuaEid createdBy;

    /**
     * Protected default constructor.<br> Required by JPA.
     *
     * @since 1.0.0
     */
    protected AbstractKapuaEntity() {
        super();
    }

    /**
     * Constructor.
     *
     * @param scopeId
     *         The scope {@link KapuaId} to set for this {@link KapuaEntity}.
     * @since 1.0.0
     */
    public AbstractKapuaEntity(KapuaId scopeId) {
        this();

        setScopeId(scopeId);
    }

    /**
     * Constructor.
     * <p>
     * It can be used to clone the {@link KapuaUpdatableEntity}
     *
     * @since 1.0.0
     */
    protected AbstractKapuaEntity(KapuaEntity entity) {
        this();

        setId(entity.getId());
        setScopeId(entity.getScopeId());
        setCreatedBy(entity.getCreatedBy());
        setCreatedOn(entity.getCreatedOn());
    }

    @Override
    public KapuaId getId() {
        return id;
    }

    @Override
    public void setId(KapuaId id) {
        this.id = KapuaEid.parseKapuaId(id);
    }

    @Override
    public KapuaId getScopeId() {
        return scopeId;
    }

    @Override
    public void setScopeId(KapuaId scopeId) {
        this.scopeId = KapuaEid.parseKapuaId(scopeId);
    }

    @Override
    public Date getCreatedOn() {
        return createdOn;
    }

    /**
     * Sets the date of creation.
     *
     * @param createdOn
     *         the date of creation.
     * @since 1.0.0
     */
    public void setCreatedOn(Date createdOn) {
        this.createdOn = createdOn;
    }

    @Override
    public KapuaId getCreatedBy() {
        return createdBy;
    }

    /**
     * Sets the identity {@link KapuaId} who has created this {@link KapuaEntity}
     *
     * @param createdBy
     *         the identity {@link KapuaId} who has created this {@link KapuaEntity}
     * @since 1.0.0
     */
    public void setCreatedBy(KapuaId createdBy) {
        this.createdBy = KapuaEid.parseKapuaId(createdBy);
    }

    /**
     * Before create action sets the {@link KapuaEntity} {@link #id}, {@link #createdBy} and {@link #createdOn}.
     *
     * @since 1.0.0
     */
    @PrePersist
    protected void prePersistsAction() {
        setId(new KapuaEid(IdGenerator.generate()));
        setCreatedBy(KapuaSecurityUtils.getSession().getUserId());
        setCreatedOn(new Date());
    }
}
