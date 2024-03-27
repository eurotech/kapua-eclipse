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

import javax.persistence.Embeddable;

import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.model.id.KapuaId;

@Embeddable
public class JobStepDefinitionPropertyId implements Serializable {

    private static final long serialVersionUID = -6533866941432301617L;

    protected KapuaEid stepDefinitionId;

    private String name;

    public JobStepDefinitionPropertyId(KapuaId stepDefinitionId, String name) {
        this.stepDefinitionId = KapuaEid.parseKapuaId(stepDefinitionId);
        this.name = name;
    }

    public JobStepDefinitionPropertyId() {

    }

    public KapuaEid getStepDefinitionId() {
        return stepDefinitionId;
    }

    public void setStepDefinitionId(KapuaEid stepDefinitionId) {
        this.stepDefinitionId = stepDefinitionId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
