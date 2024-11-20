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
package org.eclipse.kapua.service.scheduler.trigger.definition.quartz;

import com.beust.jcommander.internal.Lists;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.Job;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerDefinitionRecord;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerPropertyRecord;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerType;

/**
 * Interval {@link Job} {@link TriggerDefinitionRecord}
 *
 * @since 2.1.0
 */
public class DeviceConnectTriggerDefinition extends TriggerDefinitionRecord {

    public DeviceConnectTriggerDefinition() {
        super(null,
                "Device Connect",
                "Job execution is triggered each time the device connects to the platform. Only connections occurring between the start time and end time will trigger executions",
                TriggerType.EVENT,
                null,
                Lists.newArrayList(
                        new TriggerPropertyRecord(
                                DeviceConnectTriggerDefinitionPropertyKeys.SCOPE_ID,
                                "Identifier of the job this schedule will be applied to",
                                KapuaId.class.getName(),
                                null),
                        new TriggerPropertyRecord(
                                DeviceConnectTriggerDefinitionPropertyKeys.JOB_ID,
                                "Identifier of the scope of the job this schedule will be applied to",
                                KapuaId.class.getName(),
                                null)
                )
        );
    }
}
