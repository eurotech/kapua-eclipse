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
package org.eclipse.kapua.commons.util;

import org.eclipse.kapua.KapuaDuplicateNameException;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.KapuaIllegalNullArgumentException;
import org.eclipse.kapua.KapuaOptimisticLockingException;
import org.eclipse.kapua.kapuaIntegrityConstraintViolationException;
import org.eclipse.persistence.exceptions.DatabaseException;

import javax.persistence.OptimisticLockException;
import javax.persistence.PersistenceException;
import javax.persistence.RollbackException;
import java.sql.SQLIntegrityConstraintViolationException;

/**
 * Exception utilities
 *
 * @since 1.0
 */
public class KapuaExceptionUtils {

    private KapuaExceptionUtils() {
    }

    /**
     * Converts a low-level PersistenceException/SQLException to a business-level KapuaException.
     *
     * @param he
     */
    public static KapuaException convertPersistenceException(Exception he) {
        Exception e = he;

        // Handle the case of an incoming KapuaException
        if (he instanceof KapuaException && he.getCause() != null && he.getCause() instanceof PersistenceException) {
            e = (Exception) he.getCause();
        } else if (he instanceof KapuaException) {
            return (KapuaException) e;
        }

        // process the Persistence Exception
        KapuaException ee = null;
        if (e instanceof OptimisticLockException) {
            ee = new KapuaOptimisticLockingException(e);
        } else {
            Throwable t = e.getCause();
            if (t instanceof PersistenceException) {
                t = t.getCause();
            }
            if (t instanceof RollbackException) {
                t = t.getCause();
            }
            if (t instanceof DatabaseException) {

                // Handle Unique Constraints Exception
                DatabaseException cve = (DatabaseException) t;

                int sqlErrorCode = cve.getErrorCode();
                switch (sqlErrorCode) {

                    // SQL Error: 1062, SQLState: 23000 - ER_DUP_KEYNAME - Unique Constraints Exception
                    case 1062: {
                        // Extract the constraint name
                        // e.g. SQL Message: Duplicate entry 'test_account_1,322,584,746,357' for key 'uc_accountName'
                        String message = cve.getInternalException().getMessage();
                        String[] parts = message.split("'");
                        String constraintName = parts[parts.length - 1];
                        // populate the duplicated field name
                        // String duplicateNameField = s_uniqueConstraints.get(constraintName);
                        if (constraintName != null) {
                            ee = new KapuaDuplicateNameException(constraintName);
                        }
                    }
                    break;

                    // SQL Error: 1048, SQLSTATE: 23000 - ER_BAD_NULL_ERROR - Not Null Violation
                    case 1048: {
                        // Extract the name of the null attribute
                        // e.g. SQL Message: Column '%s' cannot be null
                        String message = cve.getInternalException().getMessage();
                        String[] parts = message.split("'");
                        String columnName = null;
                        if (parts.length == 3) {
                            columnName = parts[1];
                        }
                        // populate the null field name
                        if (columnName != null) {
                            ee = new KapuaIllegalNullArgumentException(columnName);
                        }

                    }
                    break;
                    default: {
                        if (cve.getInternalException() instanceof SQLIntegrityConstraintViolationException) {
                            String message = cve.getMessage().contains("FOREIGN KEY") ? "This entity relates to other entities and cannot be deleted." : "";
                            ee = new kapuaIntegrityConstraintViolationException(message);
                        }
                    }
                }
            }
        }
        // Handle all other Exceptions
        if (ee == null) {
            ee = KapuaException.internalError(e, "Error during Persistence Operation");
        }
        return ee;
    }

    /**
     * Walks the "cause" hierarchy of a {@link Throwable} until a {@link KapuaException} is found, and returns it
     *
     * @param t A {@link Throwable} whose "cause" hierarchy will be searched for a {@link KapuaException}
     * @return The first {@link KapuaException} in the "cause" hierarchy, or null if none is found
     * @since 1.2.0
     */
    public static KapuaException extractKapuaException(Throwable t) {
        if (t instanceof KapuaException || t == null) {
            return (KapuaException) t;
        } else {
            return extractKapuaException(t.getCause());
        }
    }
}
