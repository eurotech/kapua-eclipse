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

import org.eclipse.kapua.commons.model.query.AbstractKapuaNamedQuery;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionQuery;

/**
 * {@link JobStepDefinitionQuery} definition.
 *
 * @since 1.0.0
 */
public class JobStepDefinitionQueryImpl extends AbstractKapuaNamedQuery implements JobStepDefinitionQuery {

    /**
     * Constructor.
     *
     * @param scopeId
     *         The {@link #getScopeId()}.
     * @since 1.0.0
     */
    public JobStepDefinitionQueryImpl(KapuaId scopeId) {
        super(scopeId);
    }

    /**
     * This enables {@link JobStepDefinitionQuery} to retrieve also not scoped {@link JobStepDefinition}s since they are public.
     *
     * @return {@code true}
     * @since 2.0.0
     */
    @Override
    public boolean getNotScopedEntities() {
        return true;
    }
}
