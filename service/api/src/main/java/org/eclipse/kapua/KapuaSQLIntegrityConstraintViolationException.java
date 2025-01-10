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
 * KapuaSQLIntegrityConstraintViolationException is thrown when the value of a method parameter is invalid.
 *
 * @since 2.0.0
 */
public class KapuaSQLIntegrityConstraintViolationException extends KapuaException {

    /**
     * Constructor.
     *
     * @since 2.0.0
     */
    public KapuaSQLIntegrityConstraintViolationException() {
        super(KapuaErrorCodes.SQL_INTEGRITY_VIOLATION);
    }

    /**
     * Constructor.
     *
     * @since 2.0.0
     */
    public KapuaSQLIntegrityConstraintViolationException(String detailedMessage) {
        super(KapuaErrorCodes.SQL_INTEGRITY_VIOLATION, detailedMessage);
    }
}
