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
package org.eclipse.kapua.service.job.step.definition.device.management;

import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;

/**
 * Timeout {@link JobStepPropertyRecord} definition.
 * <p>
 * Defines the common 'timeout' {@link JobStepProperty} that all Device Management {@link JobStepDefinition}s have.
 *
 * @since 2.1.0
 */
public class TimeoutJobStepPropertyRecord extends JobStepPropertyRecord {

    /**
     * Constructor.
     * <p>
     * Shortcut for:
     * <pre>
     * new JobStepPropertyRecord("timeout",
     *                           "The amount of time the step waits a response before the operation is considered failed. The time is calculated from when the request is sent to the device",
     *                           Long.class.getName(),
     *                           "30000",
     *                           null,
     *                           Boolean.FALSE,
     *                           Boolean.FALSE,
     *                           null,
     *                           null,
     *                           "0",
     *                           null,
     *                           null)
     * </pre>
     *
     * @since 2.1.0
     */
    public TimeoutJobStepPropertyRecord() {
        super("timeout",
                "The amount of time the step waits a response before the operation is considered failed. The time is calculated from when the request is sent to the device",
                Long.class.getName(),
                "30000",
                null,
                Boolean.FALSE,
                Boolean.FALSE,
                null,
                null,
                "0",
                null,
                null);
    }
}
