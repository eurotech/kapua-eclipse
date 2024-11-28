/*******************************************************************************
 * Copyright (c) 2021, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.scheduler.exception;

import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.scheduler.trigger.Trigger;

import java.util.Date;

/**
 * {@link SchedulerServiceException} to {@code throw} when the {@link Trigger#getTriggerProperty(String)}ies
 * do not make sense with the given {@link Trigger#getTriggerDefinitionId()} and {@link Trigger#getTriggerProperties()}
 *
 * @since 1.5.0
 */
public class TriggerInvalidSchedulingException extends TriggerCannotFireException {

    private final Date startsOn;
    private final Date endsOn;
    private final KapuaId triggerDefinitionId;
    private final String scheduling;

    /**
     * Constructor.
     *
     * @param cause               The root {@link Throwable} of this {@link TriggerInvalidSchedulingException}.
     * @param startsOn            The {@link Trigger#getStartsOn()}
     * @param endsOn              The {@link Trigger#getEndsOn()}
     * @param triggerDefinitionId The {@link Trigger#getTriggerDefinitionId()}
     * @param scheduling          The scheduling extracted from the {@link Trigger#getTriggerProperties()}
     * @since 1.5.0
     */

    public TriggerInvalidSchedulingException(Throwable cause, Date startsOn, Date endsOn, KapuaId triggerDefinitionId, String scheduling) {
        super(SchedulerServiceErrorCodes.TRIGGER_INVALID_SCHEDULE, cause, triggerDefinitionId, scheduling);

        this.startsOn = startsOn;
        this.endsOn = endsOn;
        this.triggerDefinitionId = triggerDefinitionId;
        this.scheduling = scheduling;
    }

    /**
     * Gets the {@link Trigger#getStartsOn()}
     *
     * @return The {@link Trigger#getStartsOn()}
     * @since 1.5.0
     */
    public Date getStartsOn() {
        return startsOn;
    }

    /**
     * Gets the {@link Trigger#getEndsOn()}
     *
     * @return The {@link Trigger#getEndsOn()}
     * @since 1.5.0
     */
    public Date getEndsOn() {
        return endsOn;
    }

    /**
     * Gets the {@link Trigger#getTriggerDefinitionId()}
     *
     * @return The {@link Trigger#getTriggerDefinitionId()}
     * @since 1.5.0
     */
    public KapuaId getTriggerDefinitionId() {
        return triggerDefinitionId;
    }

    /**
     * Gets the invalid scheduling
     *
     * @return The invalid scheduling
     * @since 1.5.0
     */
    public String getScheduling() {
        return scheduling;
    }
}
