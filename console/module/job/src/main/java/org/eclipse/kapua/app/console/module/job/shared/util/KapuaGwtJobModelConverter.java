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
package org.eclipse.kapua.app.console.module.job.shared.util;

import org.eclipse.kapua.app.console.module.api.shared.util.KapuaGwtCommonsModelConverter;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJob;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJobExecution;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJobStep;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJobStepDefinition;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJobStepProperty;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJobTarget;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.GwtTrigger;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.GwtTriggerProperty;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.definition.GwtTriggerDefinition;
import org.eclipse.kapua.service.job.Job;
import org.eclipse.kapua.service.job.execution.JobExecution;
import org.eclipse.kapua.service.job.step.JobStep;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinition;
import org.eclipse.kapua.service.job.step.definition.JobStepProperty;
import org.eclipse.kapua.service.job.targets.JobTarget;
import org.eclipse.kapua.service.scheduler.trigger.Trigger;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerDefinition;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerProperty;

import java.util.ArrayList;
import java.util.List;

public class KapuaGwtJobModelConverter {

    private KapuaGwtJobModelConverter() {
    }

    public static GwtJob convertJob(Job job) {
        GwtJob gwtJob = new GwtJob();

        KapuaGwtCommonsModelConverter.convertUpdatableEntity(job, gwtJob);
        gwtJob.setJobName(job.getName());
        gwtJob.setDescription(job.getDescription());
        gwtJob.setJobXmlDefinition(job.getJobXmlDefinition());
        gwtJob.setJobSteps(convertJobSteps(job.getJobSteps()));

        return gwtJob;
    }

    private static List<GwtJobStep> convertJobSteps(List<JobStep> jobStepList) {
        List<GwtJobStep> gwtJobStepList = new ArrayList<GwtJobStep>();

        for (JobStep jobStep : jobStepList) {
            gwtJobStepList.add(convertJobStep(jobStep));
        }

        return gwtJobStepList;
    }

    public static GwtJobStep convertJobStep(JobStep jobStep) {
        GwtJobStep gwtJobStep = new GwtJobStep();

        KapuaGwtCommonsModelConverter.convertUpdatableEntity(jobStep, gwtJobStep);

        gwtJobStep.setJobStepName(jobStep.getName());
        gwtJobStep.setDescription(jobStep.getDescription());
        gwtJobStep.setJobId(KapuaGwtCommonsModelConverter.convertKapuaId(jobStep.getJobId()));
        gwtJobStep.setJobStepDefinitionId(KapuaGwtCommonsModelConverter.convertKapuaId(jobStep.getJobStepDefinitionId()));
        gwtJobStep.setStepIndex(jobStep.getStepIndex());
        gwtJobStep.setStepProperties(convertJobStepProperties(jobStep.getStepProperties()));

        return gwtJobStep;
    }

    private static List<GwtJobStepProperty> convertJobStepProperties(List<JobStepProperty> jobStepPropertyList) {
        List<GwtJobStepProperty> gwtJobStepPropertyList = new ArrayList<GwtJobStepProperty>();

        for (JobStepProperty jobStepProperty : jobStepPropertyList) {
            GwtJobStepProperty gwtJobStepProperty = new GwtJobStepProperty();
            gwtJobStepProperty.setPropertyName(jobStepProperty.getName());
            gwtJobStepProperty.setDescription(jobStepProperty.getDescription());
            gwtJobStepProperty.setPropertyType(jobStepProperty.getPropertyType());
            gwtJobStepProperty.setPropertyValue(jobStepProperty.getPropertyValue());
            gwtJobStepProperty.setRequired(jobStepProperty.getRequired());
            gwtJobStepProperty.setSecret(jobStepProperty.getSecret());
            gwtJobStepProperty.setExampleValue(jobStepProperty.getExampleValue());
            gwtJobStepProperty.setMinLength(jobStepProperty.getMinLength());
            gwtJobStepProperty.setMaxLength(jobStepProperty.getMaxLength());
            gwtJobStepProperty.setMinValue(jobStepProperty.getMinValue());
            gwtJobStepProperty.setMaxValue(jobStepProperty.getMaxValue());
            gwtJobStepProperty.setValidationRegex(jobStepProperty.getValidationRegex());
            gwtJobStepPropertyList.add(gwtJobStepProperty);
        }

        return gwtJobStepPropertyList;
    }

    public static GwtJobTarget convertJobTarget(JobTarget jobTarget) {
        GwtJobTarget gwtJobTarget = new GwtJobTarget();

        KapuaGwtCommonsModelConverter.convertUpdatableEntity(jobTarget, gwtJobTarget);

        gwtJobTarget.setJobTargetId(KapuaGwtCommonsModelConverter.convertKapuaId(jobTarget.getJobTargetId()));
        gwtJobTarget.setClientId(KapuaGwtCommonsModelConverter.convertKapuaId(jobTarget.getJobTargetId()));
        gwtJobTarget.setStatus(jobTarget.getStatus().toString());
        gwtJobTarget.setStepIndex(jobTarget.getStepIndex());
        gwtJobTarget.setStatusMessage(jobTarget.getStatusMessage());

        return gwtJobTarget;
    }

    public static GwtJobStepDefinition convertJobStepDefinition(JobStepDefinition jobStepDefinition) {
        GwtJobStepDefinition gwtJobStepDefinition = new GwtJobStepDefinition();

        KapuaGwtCommonsModelConverter.convertEntity(jobStepDefinition, gwtJobStepDefinition);

        gwtJobStepDefinition.setJobStepDefinitionName(jobStepDefinition.getName());
        gwtJobStepDefinition.setDescription(jobStepDefinition.getDescription());
        gwtJobStepDefinition.setProcessorName(jobStepDefinition.getProcessorName());
        gwtJobStepDefinition.setReaderName(jobStepDefinition.getReaderName());
        gwtJobStepDefinition.setWriterName(jobStepDefinition.getWriterName());
        gwtJobStepDefinition.setStepProperties(convertJobStepProperties(jobStepDefinition.getStepProperties()));
        gwtJobStepDefinition.setStepType(jobStepDefinition.getStepType().name());

        return gwtJobStepDefinition;
    }

    public static GwtTrigger convertTrigger(Trigger trigger, String triggerDefinitionName) {
        GwtTrigger gwtTrigger = new GwtTrigger();

        KapuaGwtCommonsModelConverter.convertUpdatableEntity(trigger, gwtTrigger);

        gwtTrigger.setTriggerName(trigger.getName());
        gwtTrigger.setStartsOn(trigger.getStartsOn());
        gwtTrigger.setEndsOn(trigger.getEndsOn());
        gwtTrigger.setTriggerDefinitionName(triggerDefinitionName);
        gwtTrigger.setTriggerProperties(convertTriggerProperties(trigger.getTriggerProperties()));

        return gwtTrigger;
    }

    public static GwtTriggerDefinition convertTriggerDefinition(TriggerDefinition triggerDefinition) {
        GwtTriggerDefinition gwtTriggerDefinition = new GwtTriggerDefinition();

        KapuaGwtCommonsModelConverter.convertEntity(triggerDefinition, gwtTriggerDefinition);

        gwtTriggerDefinition.setTriggerDefinitionName(triggerDefinition.getName());
        gwtTriggerDefinition.setDescription(triggerDefinition.getDescription());
        gwtTriggerDefinition.setProcessorName(triggerDefinition.getProcessorName());
        gwtTriggerDefinition.setTriggerProperties(convertTriggerProperties(triggerDefinition.getTriggerProperties()));
        gwtTriggerDefinition.setTriggerType(triggerDefinition.getTriggerType().name());

        return gwtTriggerDefinition;
    }

    private static List<GwtTriggerProperty> convertTriggerProperties(List<TriggerProperty> triggerPropertyList) {
        List<GwtTriggerProperty> gwtTriggerPropertyList = new ArrayList<GwtTriggerProperty>();

        for (TriggerProperty triggerProperty : triggerPropertyList) {
            GwtTriggerProperty gwtTriggerProperty = new GwtTriggerProperty();
            gwtTriggerProperty.setPropertyName(triggerProperty.getName());
            gwtTriggerProperty.setDescription(triggerProperty.getDescription());
            gwtTriggerProperty.setPropertyType(triggerProperty.getPropertyType());
            gwtTriggerProperty.setPropertyValue(triggerProperty.getPropertyValue());
            gwtTriggerPropertyList.add(gwtTriggerProperty);
        }

        return gwtTriggerPropertyList;
    }

    public static GwtJobExecution convertJobExecution(JobExecution jobExecution) {
        GwtJobExecution gwtJobExecution = new GwtJobExecution();
        KapuaGwtCommonsModelConverter.convertUpdatableEntity(jobExecution, gwtJobExecution);

        gwtJobExecution.setJobId(KapuaGwtCommonsModelConverter.convertKapuaId(jobExecution.getJobId()));
        gwtJobExecution.setStartedOn(jobExecution.getStartedOn());
        gwtJobExecution.setEndedOn(jobExecution.getEndedOn());
        gwtJobExecution.setLog(jobExecution.getLog());

        return gwtJobExecution;
    }

}
