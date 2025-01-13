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

import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.Job;
import org.eclipse.kapua.service.scheduler.quartz.job.KapuaJobLauncher;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerDefinitionRecord;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerPropertyRecord;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerType;
import com.beust.jcommander.internal.Lists;

/**
 * Interval {@link Job} {@link TriggerDefinitionRecord}
 *
 * @since 2.1.0
 */
public class IntervalJobTriggerDefinition extends TriggerDefinitionRecord {

    public IntervalJobTriggerDefinition() {
        super(null,
                "Interval Job",
                "Job executions are scheduled at fixed time intervals beginning from schedule start time. Executions will stop when the schedule end time is reached",
                TriggerType.TIMER,
                KapuaJobLauncher.class.getName(),
                Lists.newArrayList(
                        new TriggerPropertyRecord(
                                IntervalJobTriggerDefinitionPropertyKeys.SCOPE_ID,
                                "Identifier of the scope of the job this schedule will be applied to",
                                KapuaId.class.getName(),
                                null),
                        new TriggerPropertyRecord(
                                IntervalJobTriggerDefinitionPropertyKeys.JOB_ID,
                                "Identifier of the job this schedule will be applied to",
                                KapuaId.class.getName(),
                                null),
                        new TriggerPropertyRecord(
                                IntervalJobTriggerDefinitionPropertyKeys.INTERVAL,
                                "Fixed time between job executions in seconds",
                                Integer.class.getName(),
                                null)
                )
        );
    }
}
