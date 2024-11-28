/*******************************************************************************
 * Copyright (c) 2024, 2024 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.scheduler.exception.model;

import org.eclipse.kapua.service.scheduler.exception.SchedulerServiceErrorCodes;
import org.eclipse.kapua.service.scheduler.exception.SchedulerServiceException;
import org.eclipse.kapua.service.scheduler.exception.SchedulerServiceExceptionTest;

/**
 * {@link SchedulerServiceException} for testing.
 *
 * @see SchedulerServiceExceptionTest#testDeviceCallErrorCodesHaveMessages()
 * @since 2.1.0
 */
public class TestSchedulerServiceException extends SchedulerServiceException {

    /**
     * Constructor.
     *
     * @param code The {@link SchedulerServiceErrorCodes} to test.
     * @since 2.1.0
     */
    public TestSchedulerServiceException(SchedulerServiceErrorCodes code) {
        super(code, null);
    }
}
