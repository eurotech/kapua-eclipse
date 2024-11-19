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
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.device.management.keystore.DeviceKeystoreManagementService;
import org.eclipse.kapua.service.device.management.keystore.job.DeviceKeystoreKeypairCreateTargetProcessor;
import org.eclipse.kapua.service.device.management.keystore.model.DeviceKeystoreKeypair;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;
import org.eclipse.kapua.service.job.step.definition.device.management.TimeoutJobStepPropertyRecord;

/**
 * {@link JobStepDefinition} to perform {@link DeviceKeystoreManagementService#createKeystoreKeypair(KapuaId, KapuaId, DeviceKeystoreKeypair, Long)}
 *
 * @since 2.0.0
 */
public class DeviceKeystoreKeypairCreateJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = -1091068929445064691L;

    public DeviceKeystoreKeypairCreateJobStepDefinition() {
        super(null,
                "Keystore Keypair Create",
                "Execute request to create and store a private-public key pair to the target devices of the Job",
                JobStepType.TARGET,
                null,
                DeviceKeystoreKeypairCreateTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceKeystoreKeypairCreatePropertyKeys.KEYSTORE_ID,
                                "Identifier of the device keystore where the certificate will be added",
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
                                "Alias of the key pair",
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
                                "Size of the keys (bit length)",
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
                                "Name of the algorithm used to create the key pair",
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
                                "Name of the algorithm used to sign the key pair",
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
                                "Attributes added to the subject field of the certificate",
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
                        new TimeoutJobStepPropertyRecord()
                )
        );
    }
}
