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
import org.eclipse.kapua.service.device.management.keystore.job.DeviceKeystoreCertificateCreateTargetProcessor;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;

public class DeviceKeystoreCertificateCreateJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = 5342438753269731362L;

    public DeviceKeystoreCertificateCreateJobStepDefinition() {
        super(null,
                "Keystore Certificate Create",
                "Create a Certificate on a Device keystore",
                JobStepType.TARGET,
                null,
                DeviceKeystoreCertificateCreateTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceKeystoreCertificateCreatePropertyKeys.KEYSTORE_ID,
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
                        new JobStepPropertyRecord(
                                DeviceKeystoreCertificateCreatePropertyKeys.TIMEOUT,
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
