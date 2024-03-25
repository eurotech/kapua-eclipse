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
import org.eclipse.kapua.service.device.management.keystore.job.DeviceKeystoreKeypairCreateTargetProcessor;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;

public class DeviceKeystoreKeypairCreateJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = -1091068929445064691L;

    public DeviceKeystoreKeypairCreateJobStepDefinition() {
        super(null,
                "Keystore Keypair Create",
                "Create a Keypair on a Device keystore",
                JobStepType.TARGET,
                null,
                DeviceKeystoreKeypairCreateTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceKeystoreKeypairCreatePropertyKeys.KEYSTORE_ID,
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
                                DeviceKeystoreKeypairCreatePropertyKeys.ALIAS,
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
                                DeviceKeystoreKeypairCreatePropertyKeys.SIZE,
                                Integer.class.getName(),
                                null,
                                "4096",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new JobStepPropertyRecord(
                                DeviceKeystoreKeypairCreatePropertyKeys.ALGORITHM,
                                String.class.getName(),
                                null,
                                "RSA",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new JobStepPropertyRecord(
                                DeviceKeystoreKeypairCreatePropertyKeys.SIGNATURE_ALGORITHM,
                                String.class.getName(),
                                null,
                                "SHA256withRSA",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new JobStepPropertyRecord(
                                DeviceKeystoreKeypairCreatePropertyKeys.ATTRIBUTES,
                                String.class.getName(),
                                null,
                                "CN=My Common Name,O=My Org,C=US",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                null,
                                null,
                                null,
                                null),
                        new JobStepPropertyRecord(
                                DeviceKeystoreKeypairCreatePropertyKeys.TIMEOUT,
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
