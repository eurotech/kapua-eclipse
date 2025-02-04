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
package org.eclipse.kapua;

/**
 * kapuaIntegrityConstraintViolationException is thrown when the integrity constraints of the underlying datastore have been violated
 *
 * @since 2.0.0
 */
public class kapuaIntegrityConstraintViolationException extends KapuaException {

    /**
     * Constructor.
     *
     * @since 2.0.0
     */
    public kapuaIntegrityConstraintViolationException() {
        super(KapuaErrorCodes.DATASTORE_INTEGRITY_VIOLATION);
    }

    /**
     * Constructor.
     *
     * @since 2.0.0
     */
    public kapuaIntegrityConstraintViolationException(String detailedMessage) {
        super(KapuaErrorCodes.DATASTORE_INTEGRITY_VIOLATION, detailedMessage);
    }
}
