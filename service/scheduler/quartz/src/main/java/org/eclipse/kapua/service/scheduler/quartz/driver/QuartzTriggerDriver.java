/*******************************************************************************
 * Copyright (c) 2019, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.scheduler.quartz.driver;

import com.google.common.base.Strings;
import org.eclipse.kapua.KapuaIllegalArgumentException;
import org.eclipse.kapua.KapuaIllegalNullArgumentException;
import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.model.type.ObjectTypeConverter;
import org.eclipse.kapua.model.type.ObjectValueConverter;
import org.eclipse.kapua.service.job.Job;
import org.eclipse.kapua.service.scheduler.quartz.driver.exception.CannotAddQuartzJobException;
import org.eclipse.kapua.service.scheduler.quartz.driver.exception.CannotScheduleJobException;
import org.eclipse.kapua.service.scheduler.quartz.driver.exception.CannotUnscheduleJobException;
import org.eclipse.kapua.service.scheduler.quartz.driver.exception.QuartzTriggerDriverException;
import org.eclipse.kapua.service.scheduler.quartz.driver.exception.SchedulerNotAvailableException;
import org.eclipse.kapua.service.scheduler.quartz.driver.exception.TriggerNeverFiresException;
import org.eclipse.kapua.service.scheduler.quartz.job.KapuaJobLauncher;
import org.eclipse.kapua.service.scheduler.trigger.Trigger;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerProperty;
import org.quartz.CronExpression;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobBuilder;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.ScheduleBuilder;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.SimpleScheduleBuilder;
import org.quartz.TriggerBuilder;
import org.quartz.TriggerKey;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.validation.constraints.NotNull;
import java.text.ParseException;
import java.util.Date;
import java.util.TimeZone;

/**
 * Utility class to crate Quartz {@link org.quartz.Trigger}s.
 *
 * @since 1.1.0
 */
public class QuartzTriggerDriver {

    private static final Logger LOG = LoggerFactory.getLogger(QuartzTriggerDriver.class);

    private static Scheduler scheduler;

    private QuartzTriggerDriver() {
    }

    /**
     * Creates a Quartz {@link org.quartz.Trigger} that starts now.
     *
     * @param scopeId        The {@link Job#getScopeId()} to start.
     * @param jobId          The {@link Job#getId()} to start
     * @param uniqueId       A unique {@link KapuaId} to associate with the Quartz {@link org.quartz.Trigger}.
     * @param triggerDataMap The {@link JobDataMap} with properties for the Quartz {@link org.quartz.Trigger}
     * @since 1.1.0
     */
    public static void createQuartzTrigger(@NotNull KapuaId scopeId, @NotNull KapuaId jobId, @NotNull KapuaId uniqueId, @NotNull JobDataMap triggerDataMap) throws QuartzTriggerDriverException {
        JobDetail kapuaJobLauncherJobDetail = getJobDetail();

        // Quartz Trigger data map definition
        TriggerKey triggerKey = TriggerKey.triggerKey(jobId.toCompactId().concat("-").concat(uniqueId.toCompactId()), scopeId.toCompactId());

        // Quartz Trigger definition
        TriggerBuilder<org.quartz.Trigger> triggerBuilder = TriggerBuilder.newTrigger()
                .forJob(kapuaJobLauncherJobDetail)
                .withIdentity(triggerKey)
                .usingJobData(triggerDataMap)
                .startNow();

        org.quartz.Trigger quarztTrigger = triggerBuilder.build();
        try {
            getScheduler().scheduleJob(quarztTrigger);
        } catch (SchedulerException se) {
            throw new CannotScheduleJobException(se, kapuaJobLauncherJobDetail, triggerKey, triggerDataMap);
        }
    }

    public static void createIntervalJobTrigger(@NotNull Trigger trigger) throws KapuaIllegalNullArgumentException, QuartzTriggerDriverException {
        Integer interval = null;

        for (TriggerProperty tp : trigger.getTriggerProperties()) {
            if ("interval".equals(tp.getName())) {
                interval = (Integer) ObjectValueConverter.fromString(tp.getPropertyValue(), Integer.class);
                break;
            }
        }

        if (interval == null) {
            throw new KapuaIllegalNullArgumentException("interval");
        }

        createQuartzTriggerWithSchedule(
                trigger,
                SimpleScheduleBuilder.repeatSecondlyForever(interval)
                        .withMisfireHandlingInstructionFireNow() // This option force a misfired trigger to be always fired
        );
    }


    public static void createCronJobTrigger(@NotNull Trigger trigger) throws KapuaIllegalArgumentException, QuartzTriggerDriverException {
        String cron = null;

        for (TriggerProperty tp : trigger.getTriggerProperties()) {
            if ("cronExpression".equals(tp.getName())) {
                cron = (String) ObjectValueConverter.fromString(tp.getPropertyValue(), String.class);
                break;
            }
        }

        if (Strings.isNullOrEmpty(cron)) {
            throw new KapuaIllegalNullArgumentException("cronExpression");
        }

        CronExpression cronExpression;
        try {
            cronExpression = new CronExpression(cron);
        }
        catch (ParseException pe) {
            LOG.warn("Error while parsing cron {} expression for Trigger {} in scope {}", cron, trigger.getId(), trigger.getScopeId(), pe);
            throw new KapuaIllegalArgumentException("cronExpression", cron);
        }

        CronScheduleBuilder cronScheduleBuilder =
            CronScheduleBuilder
                .cronSchedule(cronExpression)
                .withMisfireHandlingInstructionFireAndProceed() // This option force a misfired trigger to be always fired
                .inTimeZone(TimeZone.getTimeZone("UTC"));

        createQuartzTriggerWithSchedule(trigger, cronScheduleBuilder);
    }

    public static void deleteTrigger(@NotNull Trigger trigger) throws CannotUnscheduleJobException {
        TriggerKey triggerKey = TriggerKey.triggerKey(trigger.getId().toCompactId(), trigger.getScopeId().toCompactId());

        try {
            getScheduler().unscheduleJob(triggerKey);
        } catch (SchedulerException | SchedulerNotAvailableException se) {
            throw new CannotUnscheduleJobException(se, triggerKey);
        }
    }
    // Private methods

    private static void createQuartzTriggerWithSchedule(Trigger trigger, ScheduleBuilder<?> scheduleBuilder) throws QuartzTriggerDriverException {
        JobDetail kapuaJobLauncherJobDetail = getJobDetail();
        // Quartz Trigger data map definition
        TriggerKey triggerKey = TriggerKey.triggerKey(trigger.getId().toCompactId(), trigger.getScopeId().toCompactId());

        JobDataMap triggerDataMap = new JobDataMap();
        try {
            for (TriggerProperty tp : trigger.getTriggerProperties()) {
                if (KapuaId.class.getName().equals(tp.getPropertyType())) {
                    triggerDataMap.put(tp.getName(), KapuaEid.parseCompactId(tp.getPropertyValue()));
                } else {
                    triggerDataMap.put(tp.getName(), ObjectValueConverter.fromString(tp.getPropertyValue(), ObjectTypeConverter.fromString(tp.getPropertyType())));
                }
            }
        } catch (ClassNotFoundException cnfe) {
            throw new RuntimeException(cnfe);
        }
        // Quartz Trigger definition
        TriggerBuilder<org.quartz.Trigger> triggerBuilder = TriggerBuilder.newTrigger()
                .forJob(kapuaJobLauncherJobDetail)
                .withIdentity(triggerKey)
                .usingJobData(triggerDataMap)
                .startAt(trigger.getStartsOn())
                .endAt(trigger.getEndsOn());

        triggerBuilder.withSchedule(scheduleBuilder);

        org.quartz.Trigger quartzTrigger = triggerBuilder.build();
        // Check that fires
        if (quartzTrigger.getFireTimeAfter(new Date()) == null) {
            throw new TriggerNeverFiresException(quartzTrigger);
        }
        // Schedule trigger
        try {
            getScheduler().scheduleJob(quartzTrigger);
        } catch (SchedulerException se) {
            throw new CannotScheduleJobException(se, kapuaJobLauncherJobDetail, triggerKey, triggerDataMap);
        }
    }

    private static JobDetail getJobDetail() throws CannotAddQuartzJobException, SchedulerNotAvailableException {

        JobKey jobkey = JobKey.jobKey(KapuaJobLauncher.class.getName(), "USER");
        JobDetail kapuaJobLauncherJobDetail;
        try {
            kapuaJobLauncherJobDetail = getScheduler().getJobDetail(jobkey);

            if (kapuaJobLauncherJobDetail == null) {
                kapuaJobLauncherJobDetail = JobBuilder.newJob(KapuaJobLauncher.class)
                        .withIdentity(jobkey)
                        .storeDurably()
                        .build();

                getScheduler().addJob(kapuaJobLauncherJobDetail, false);
            }
        } catch (SchedulerException se) {
            throw new CannotAddQuartzJobException(se, KapuaJobLauncher.class, jobkey);
        }
        return kapuaJobLauncherJobDetail;
    }

    private static Scheduler getScheduler() throws SchedulerNotAvailableException {
        if (scheduler == null) {
            initQuarztScheduler();
        }

        return scheduler;
    }

    private static synchronized void initQuarztScheduler() throws SchedulerNotAvailableException {
        if (scheduler != null) {
            return;
        }

        LOG.info("Initializing Quartz Scheduler instance...");
        int attempt = 0;
        int maxAttempt = 3;
        do {
            try {
                SchedulerFactory sf = new StdSchedulerFactory();
                scheduler = sf.getScheduler();
            } catch (SchedulerException se) {
                if (attempt++ < maxAttempt) {
                    LOG.warn("Initializing Quartz Scheduler instance... ERROR! Retrying in a while ({}/{})... Error occurred: {}", attempt, maxAttempt, se.getMessage());
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                    }
                } else {
                    LOG.error("Initializing Quartz Scheduler instance... ERROR!", se);
                    throw new SchedulerNotAvailableException(se);
                }
            }
        } while (scheduler == null);

        LOG.info("Initializing Quartz Scheduler instance... DONE!");
    }
}
