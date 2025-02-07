/*******************************************************************************
 * Copyright (c) 2025, 2025 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.exception;

import org.eclipse.kapua.KapuaErrorCodes;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.KapuaService;

/**
 * {@link KapuaException} to throw when a {@link KapuaService} feature is disabled per {@link KapuaService} configuration or by other means/
 *
 * @since 2.1.0
 */
public class KapuaFeatureDisabledException extends KapuaException {

    private final KapuaId scopeId;

    /**
     * Constructor.
     *
     * @since 2.1.0
     */
    public KapuaFeatureDisabledException(KapuaId scopeId) {
        super(KapuaErrorCodes.SERVICE_DISABLED, scopeId);

        this.scopeId = scopeId;
    }

    /**
     * Gets the Account.id for which the feature is disabled
     *
     * @return The Account.id for which the feature is disabled
     */
    public KapuaId getScopeId() {
        return scopeId;
    }
}
