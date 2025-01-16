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
public class CronJobTriggerDefinition extends TriggerDefinitionRecord {

    public CronJobTriggerDefinition() {
        super(null,
                "Cron Job",
                "Job executions are scheduled through a CRON expression. Only CRON events occurring between the start time and end time will trigger executions",
                TriggerType.TIMER,
                KapuaJobLauncher.class.getName(),
                Lists.newArrayList(
                        new TriggerPropertyRecord(
                                CronJobTriggerDefinitionPropertyKeys.SCOPE_ID,
                                "Identifier of the scope of the job this schedule will be applied to",
                                KapuaId.class.getName(),
                                null),
                        new TriggerPropertyRecord(
                                CronJobTriggerDefinitionPropertyKeys.JOB_ID,
                                "Identifier of the job this schedule will be applied to",
                                KapuaId.class.getName(),
                                null),
                        new TriggerPropertyRecord(
                                CronJobTriggerDefinitionPropertyKeys.CRON_EXPRESSION,
                                "The Cron expression that defines the schedule of executions in UTC time zone. The expression consists of 6 or 7 space-separated fields: [seconds] [minutes] [hours] [day of month] [month] [day of week] [year] ([year] is optional). For example, the expression \"0 0/5 13,17 * * ?\" triggers a job execution every 5 minutes starting at 1pm until 1:55pm and starting at 5pm until 5:55pm every day. Check Everyware Cloud documentation for more details on Cron expressions",
                                String.class.getName(),
                                null)
                )
        );
    }
}
