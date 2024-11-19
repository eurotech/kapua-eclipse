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
package org.eclipse.kapua.service.device.management.bundle.job.definition;

import com.beust.jcommander.internal.Lists;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.device.management.bundle.DeviceBundleManagementService;
import org.eclipse.kapua.service.device.management.bundle.job.DeviceBundleStartTargetProcessor;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;
import org.eclipse.kapua.service.job.step.definition.device.management.TimeoutJobStepPropertyRecord;

/**
 * {@link JobStepDefinition} to perform {@link DeviceBundleManagementService#start(KapuaId, KapuaId, String, Long)}.
 *
 * @since 2.0.0
 */
public class DeviceBundleStartJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = -385206687676303753L;

    public DeviceBundleStartJobStepDefinition() {
        super(null,
                "Bundle Start",
                "Execute request to start a bundle to the target devices of the Job",
                JobStepType.TARGET,
                null,
                DeviceBundleStartTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceBundlePropertyKeys.BUNDLE_ID,
                                "Numeric identifier of the bundle installed in the device",
                                String.class.getName(),
                                null,
                                null,
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new TimeoutJobStepPropertyRecord()
                )
        );
    }
}
