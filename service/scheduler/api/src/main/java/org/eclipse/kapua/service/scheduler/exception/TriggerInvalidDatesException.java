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

import org.eclipse.kapua.service.scheduler.trigger.Trigger;

import java.util.Date;

/**
 * {@link SchedulerServiceException} to {@code throw} when the {@link org.eclipse.kapua.service.scheduler.trigger.Trigger} dates do not make sense with the current date.
 *
 * @since 1.5.0
 */
public class TriggerInvalidDatesException extends TriggerCannotFireException {

    private final Date startsOn;
    private final Date endsOn;
    private final Date currentDate;

    /**
     * Constructor
     *
     * @param startsOn    The {@link Trigger#getStartsOn()}
     * @param endsOn      The {@link Trigger#getEndsOn()}
     * @param currentDate The current {@link Date}
     */
    public TriggerInvalidDatesException(Date startsOn, Date endsOn, Date currentDate) {
        super(SchedulerServiceErrorCodes.TRIGGER_INVALID_DATES, null);

        this.startsOn = startsOn;
        this.endsOn = endsOn;
        this.currentDate = currentDate;
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
     * Gets the current {@link Date} at the moment of the check.
     *
     * @return The current {@link Date} at the moment of the check.
     * @since 1.5.0
     */
    public Date getCurrentDate() {
        return currentDate;
    }
}
