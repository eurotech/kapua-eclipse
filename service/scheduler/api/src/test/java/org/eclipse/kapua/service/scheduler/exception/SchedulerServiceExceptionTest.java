/*******************************************************************************
 * Copyright (c) 2024, 2024 Eurotech and/or its affiliates and others
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
import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.eclipse.kapua.service.scheduler.exception.model.TestSchedulerServiceException;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * {@link SchedulerServiceException}s tests.
 *
 * @since 2.1.0
 */
@Category(JUnitTests.class)
public class SchedulerServiceExceptionTest {

    private final Throwable aCause = new Throwable("This is the cause");

    DateFormat dataFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

    private final Date startsOn = dataFormat.parse("2020/01/01 00:00:00");
    private final Date endOn = dataFormat.parse("2025/01/01 00:00:00");

    private final Date currentDate = dataFormat.parse("2024/01/01 00:00:00");

    private final KapuaId aTriggerDefinitionId = KapuaId.ONE;
    private final String aSchedule = "1 1 1 1 1 ? 2024";

    public SchedulerServiceExceptionTest() throws ParseException {
    }

    @Test
    public void testDeviceCallErrorCodesHaveMessages() {
        for (SchedulerServiceErrorCodes errorCode : SchedulerServiceErrorCodes.values()) {
            SchedulerServiceException schedulerServiceException = new TestSchedulerServiceException(errorCode);

            Assert.assertNotEquals("SchedulerServiceErrorCodes." + errorCode + " doesn't have an error message", "Error: ", schedulerServiceException.getMessage());
            Assert.assertNotEquals("SchedulerServiceErrorCodes." + errorCode + " doesn't have an error message", "Error: ", schedulerServiceException.getLocalizedMessage());
        }
    }

    @Test
    public void testTriggerInvalidDatesException() {
        String exceptionMessage = "Trigger with given startsOn and endsOn will never fire according to the current date";

        TriggerInvalidDatesException triggerInvalidDatesException = new TriggerInvalidDatesException(startsOn, endOn, currentDate);

        Assert.assertEquals(SchedulerServiceErrorCodes.TRIGGER_INVALID_DATES, triggerInvalidDatesException.getCode());
        Assert.assertNull(triggerInvalidDatesException.getCause());
        Assert.assertEquals(startsOn, triggerInvalidDatesException.getStartsOn());
        Assert.assertEquals(endOn, triggerInvalidDatesException.getEndsOn());
        Assert.assertEquals(currentDate, triggerInvalidDatesException.getCurrentDate());
        Assert.assertEquals(exceptionMessage, triggerInvalidDatesException.getMessage());
        Assert.assertEquals(exceptionMessage, triggerInvalidDatesException.getLocalizedMessage());
    }

    @Test
    public void testTriggerInvalidSchedulingException() {
        String exceptionMessage = "Trigger with given startsOn and endsOn triggerDefinitionId '" + aTriggerDefinitionId + "' will never fire according to the given schedule '" + aSchedule + "'";

        TriggerInvalidSchedulingException triggerInvalidDatesException = new TriggerInvalidSchedulingException(aCause, startsOn, endOn, aTriggerDefinitionId, aSchedule);

        Assert.assertEquals(SchedulerServiceErrorCodes.TRIGGER_INVALID_SCHEDULE, triggerInvalidDatesException.getCode());
        Assert.assertEquals(aCause, triggerInvalidDatesException.getCause());
        Assert.assertEquals(startsOn, triggerInvalidDatesException.getStartsOn());
        Assert.assertEquals(endOn, triggerInvalidDatesException.getEndsOn());
        Assert.assertEquals(aTriggerDefinitionId, triggerInvalidDatesException.getTriggerDefinitionId());
        Assert.assertEquals(aSchedule, triggerInvalidDatesException.getScheduling());
        Assert.assertEquals(exceptionMessage, triggerInvalidDatesException.getMessage());
        Assert.assertEquals(exceptionMessage, triggerInvalidDatesException.getLocalizedMessage());
    }
}
