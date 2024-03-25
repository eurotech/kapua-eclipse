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

import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.model.id.KapuaId;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.math.BigInteger;

@Embeddable
public class JobStepPropertyForAlignerId implements Serializable {

    private static final long serialVersionUID = -6533866941432301617L;
    @Basic
    @Column(name = "step_definition_id", nullable = false, updatable = false)
    private BigInteger stepDefinitionId;

    @Basic
    @Column(name = "name", nullable = false, updatable = false)
    private String name;

    public JobStepPropertyForAlignerId() {
    }

    public JobStepPropertyForAlignerId(KapuaId stepDefinitionId, String name) {
        setStepDefinitionId(stepDefinitionId);
        setName(name);
    }

    public KapuaEid getStepDefinitionId() {
        return new KapuaEid(stepDefinitionId);
    }

    public void setStepDefinitionId(KapuaId stepDefinitionId) {
        this.stepDefinitionId = stepDefinitionId.getId();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
