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
package org.eclipse.kapua.service.device.management.packages.job.definition;

import com.beust.jcommander.internal.Lists;
import org.eclipse.kapua.service.device.management.packages.job.DevicePackageDownloadTargetProcessor;
import org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;

public class DevicePackageDownloadJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = 867888593933132944L;

    public DevicePackageDownloadJobStepDefinition() {
        super(null,
                "Package Download / Install",
                "Downloads a package using the Device Packages Management Service",
                JobStepType.TARGET,
                null,
                DevicePackageDownloadTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DevicePackageDownloadPropertyKeys.PACKAGE_DOWNLOAD_REQUEST,
                                DevicePackageDownloadRequest.class.getName(),
                                null,
                                "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<downloadRequest>\n   <uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.demo.heater_1.0.300.dp</uri>\n   <name>heater</name>\n   <version>1.0.300</version>\n   <install>true</install>\n</downloadRequest>",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new JobStepPropertyRecord(
                                DevicePackageDownloadPropertyKeys.TIMEOUT,
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
