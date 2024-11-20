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
import org.eclipse.kapua.service.device.management.bundle.job.DeviceBundleStartTargetProcessor;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;

public class DeviceBundleStartJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = -385206687676303753L;

    public DeviceBundleStartJobStepDefinition() {
        super(null,
                "Bundle Start",
                "Starts a bundle using the Device Bundle Management Service",
                JobStepType.TARGET,
                null,
                DeviceBundleStartTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceBundlePropertyKeys.BUNDLE_ID,
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
                        new JobStepPropertyRecord(
                                DeviceBundlePropertyKeys.TIMEOUT,
                                Long.class.getName(),
                                "30000",
                                null,
                                Boolean.FALSE,
                                Boolean.FALSE,
                                null,
                                null,
                                "0",
                                null,
                                null)
                )
        );
    }
}
