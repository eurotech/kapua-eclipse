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
package org.eclipse.kapua.service.device.management.configuration.job.definition;

import com.beust.jcommander.internal.Lists;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration;
import org.eclipse.kapua.service.device.management.configuration.DeviceConfigurationManagementService;
import org.eclipse.kapua.service.device.management.configuration.job.DeviceConfigurationPutTargetProcessor;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepPropertyRecord;
import org.eclipse.kapua.service.job.step.definition.JobStepType;
import org.eclipse.kapua.service.job.step.definition.device.management.TimeoutJobStepPropertyRecord;

/**
 * {@link JobStepDefinition} to perform {@link DeviceConfigurationManagementService#put(KapuaId, KapuaId, DeviceConfiguration, Long)}.
 *
 * @since 2.0.0
 */
public class DeviceConfigurationPutJobStepDefinition extends JobStepDefinitionRecord {

    private static final long serialVersionUID = -546796682677301525L;

    public DeviceConfigurationPutJobStepDefinition() {
        super(null,
                "Configuration Put",
                "Request to execute a configuration update to the target devices of the Job",
                JobStepType.TARGET,
                null,
                DeviceConfigurationPutTargetProcessor.class.getName(),
                null,
                Lists.newArrayList(
                        new JobStepPropertyRecord(
                                DeviceConfigurationPutPropertyKeys.CONFIGURATION,
                                "XML string that defines the configuration update sent",
                                DeviceConfiguration.class.getName(),
                                null,
                                "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<deviceConfigurations xmlns:ns0=\"http://www.osgi.org/xmlns/metatype/v1.2.0\">\n    <configuration>\n    <id>org.eclipse.kura.demo.heater.Heater</id>\n    <properties>\n        <property name=\"temperature.increment\" array=\"false\" encrypted=\"false\" type=\"Float\">\n            <value>0.25</value>\n        </property>\n        <property name=\"publish.rate\" array=\"false\" encrypted=\"false\" type=\"Integer\">\n            <value>60</value>\n        </property>\n        <property name=\"program.stopTime\" array=\"false\" encrypted=\"false\" type=\"String\">\n            <value>22:00</value>\n        </property>\n        <property name=\"publish.retain\" array=\"false\" encrypted=\"false\" type=\"Boolean\">\n            <value>false</value>\n        </property>\n        <property name=\"service.pid\" array=\"false\" encrypted=\"false\" type=\"String\">\n            <value>org.eclipse.kura.demo.heater.Heater</value>\n        </property>\n        <property name=\"kura.service.pid\" array=\"false\" encrypted=\"false\" type=\"String\">\n            <value>org.eclipse.kura.demo.heater.Heater</value>\n        </property>\n        <property name=\"program.startTime\" array=\"false\" encrypted=\"false\" type=\"String\">\n            <value>06:00</value>\n        </property>\n        <property name=\"mode\" array=\"false\" encrypted=\"false\" type=\"String\">\n            <value>Program</value>\n        </property>\n        <property name=\"publish.semanticTopic\" array=\"false\" encrypted=\"false\" type=\"String\">\n            <value>data/210</value>\n        </property>\n        <property name=\"manual.setPoint\" array=\"false\" encrypted=\"false\" type=\"Float\">\n            <value>30.0</value>\n        </property>\n        <property name=\"publish.qos\" array=\"false\" encrypted=\"false\" type=\"Integer\">\n            <value>2</value>\n        </property>\n        <property name=\"temperature.initial\" array=\"false\" encrypted=\"false\" type=\"Float\">\n            <value>13.0</value>\n        </property>\n        <property name=\"program.setPoint\" array=\"false\" encrypted=\"false\" type=\"Float\">\n            <value>30.0</value>\n        </property>\n    </properties>\n    </configuration>\n</deviceConfigurations>",
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
