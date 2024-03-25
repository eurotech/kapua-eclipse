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
package org.eclipse.kapua.service.device.management.keystore.job.definition;

import com.beust.jcommander.internal.Lists;
import org.eclipse.kapua.service.device.management.keystore.job.DeviceKeystoreItemDeleteTargetProcessor;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;

public class DeviceKeystoreItemDeleteJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = 1282749172519349072L;

    public DeviceKeystoreItemDeleteJobStepDefinition() {
        super(null,
                "Keystore Item Delete",
                "Deletes a keystore item a Device",
                JobStepType.TARGET,
                null,
                DeviceKeystoreItemDeleteTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceKeystoreItemDeletePropertyKeys.KEYSTORE_ID,
                                String.class.getName(),
                                null,
                                "SSLKeystore",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new JobStepPropertyRecord(
                                DeviceKeystoreItemDeletePropertyKeys.ALIAS,
                                String.class.getName(),
                                null,
                                "ssl-eclipse",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new JobStepPropertyRecord(
                                DeviceKeystoreItemDeletePropertyKeys.TIMEOUT,
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
