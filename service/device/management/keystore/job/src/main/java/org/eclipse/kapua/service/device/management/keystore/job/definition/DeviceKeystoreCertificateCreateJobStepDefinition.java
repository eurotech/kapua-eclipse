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
import org.eclipse.kapua.service.device.management.keystore.job.DeviceKeystoreCertificateCreateTargetProcessor;
import org.eclipse.kapua.service.device.management.keystore.model.DeviceKeystoreCertificate;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;
import org.eclipse.kapua.service.job.step.definition.device.management.TimeoutJobStepPropertyRecord;

/**
 * {@link JobStepDefinition} to perform {@link DeviceKeystoreManagementService#createKeystoreCertificate(KapuaId, KapuaId, DeviceKeystoreCertificate, Long)}.
 *
 * @since 2.0.0
 */
public class DeviceKeystoreCertificateCreateJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = 5342438753269731362L;

    public DeviceKeystoreCertificateCreateJobStepDefinition() {
        super(null,
                "Keystore Certificate Create",
                "Execute request to store a certificate to the target devices of the Job",
                JobStepType.TARGET,
                null,
                DeviceKeystoreCertificateCreateTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceKeystoreCertificateCreatePropertyKeys.KEYSTORE_ID,
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
                                DeviceKeystoreCertificateCreatePropertyKeys.ALIAS,
                                "Alias of the certificate",
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
                                DeviceKeystoreCertificateCreatePropertyKeys.CERTIFICATE,
                                "Certificate definition in PEM format",
                                String.class.getName(),
                                null,
                                "-----BEGIN CERTIFICATE-----\n    [...]\n-----END CERTIFICATE-----\n",
                                Boolean.TRUE,
                                Boolean.FALSE,
                                null,
                                1048576,
                                null,
                                null,
                                null),
                        new TimeoutJobStepPropertyRecord()
                )
        );
    }
}
