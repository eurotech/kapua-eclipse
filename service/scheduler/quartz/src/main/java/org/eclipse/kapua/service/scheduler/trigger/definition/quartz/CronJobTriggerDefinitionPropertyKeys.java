/*******************************************************************************
 * Copyright (c) 2017, 2022 Eurotech and/or its affiliates and others
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

import org.eclipse.kapua.service.job.step.definition.JobPropertyKey;

public class CronJobTriggerDefinitionPropertyKeys implements JobPropertyKey {

    public static final String SCOPE_ID = "scopeId";
    public static final String JOB_ID = "jobId";
    public static final String CRON_EXPRESSION = "cronExpression";

    private CronJobTriggerDefinitionPropertyKeys() {
    }
}
