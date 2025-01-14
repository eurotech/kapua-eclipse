###############################################################################
# Copyright (c) 2020, 2022 Eurotech and/or its affiliates and others
#
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#     Eurotech
###############################################################################
@scheduler
@env_none

Feature: Scheduler Service

  Scenario: Create scheduler with valid schedule name
  Creating scheduler with valid schedule name property.

@setup
@KapuaProperties("locator.class.impl=org.eclipse.kapua.qa.common.MockedLocator")
  Scenario: Initialize test environment
    Given Init Jaxb Context
    And Init Security Context

  Scenario: Create scheduler with valid schedule name
  Creating scheduler with valid schedule name property.
    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "triggerExample" is created
    And The trigger is set to start today at "00:00"
    Then I create a new trigger from the existing creator with previously defined date properties

  Scenario: Create scheduler with invalid schedule name
  Creating scheduler with invalid schedule name property.

    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "triggerExample?" is created
    And The trigger is set to start today at "00:00"
    And I expect the exception "KapuaIllegalArgumentException" with the text "*"
    Then I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown

  Scenario: Create scheduler with empty schedule name
  Creating scheduler with empty schedule name property.

    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "" is created
    And The trigger is set to start today at "00:00"
    And I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    Then I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown

  Scenario: Create scheduler with short schedule name
  Creating scheduler with too short schedule name property.

    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "tr" is created
    And The trigger is set to start today at "00:00"
    And I expect the exception "KapuaIllegalArgumentException" with the text "*"
    Then I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown

  Scenario: Create scheduler with too long schedule name
  Creating scheduler with too long schedule name property.

    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "trigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigerExampletrigertrigerExampletri" is created
    And The trigger is set to start today at "00:00"
    And I expect the exception "KapuaIllegalArgumentException" with the text "*"
    Then I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown

  Scenario: Create scheduler without start date
  Creating scheduler with valid schedule name property, but without starts on date.

    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "triggerExample?" is created
    And I expect the exception "KapuaIllegalArgumentException" with the text "*"
    Then I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown

  Scenario: Create scheduler with end date before start date
  Creating scheduler with ends on date before stars on date.

    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "triggerExample" is created
    And The trigger is set to start on "10-10-2018" at "6:00"
    And The trigger is set to end on "09-10-2018" at "6:00"
    And I expect the exception "TriggerInvalidDatesException" with the text "Trigger with given startsOn and endsOn will never fire according to the current date"
    Then I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown

  Scenario: Create scheduler with correct end date
  Creating scheduler with valid ends on date property.

    Given I create a job with the name "job1"
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "triggerExample" is created
    And The trigger is set to start on "10-10-2018" at "6:00"
    And The trigger is set to end tomorrow at "6:00"
    Then I create a new trigger from the existing creator with previously defined date properties
    And No exception was thrown

  Scenario: Create scheduler with valid cron job trigger property
  Creating scheduler with Cron Job scheduler property and valid cron job trigger expression.

    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    Then I set cron expression to "0 12 1 * * ?"
    And I create a new trigger from the existing creator with previously defined date properties

  Scenario: Create scheduler with invalid cron job trigger  property
  Creating scheduler with Cron Job scheduler property and invalid cron job trigger expression.

    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    Then I set cron expression to "12 1 ? ? *"
    And I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument cronExpression"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown

  Scenario: Create scheduler without Cron Job Trigger property
  Creating scheduler with Cron Job scheduler property and empty cron job trigger expression.

    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    Then I set cron expression to ""
    And I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown

  Scenario: Create scheduler with valid Retry Interval property
  Creating scheduler with Interval Job scheduler property and valid retry interval expression.

    Given I create a job with the name "job1"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to 2
    And I try to create a new trigger entity from the existing creator

  Scenario: Create scheduler without Retry Interval property
  Creating scheduler with Interval Job scheduler property and empty retry interval expression.

    Given I create a job with the name "job1"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to null
    And I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    And I try to create a new trigger entity from the existing creator
    Then An exception was thrown

  Scenario: Update scheduler name
  Creating scheduler with proper properties. Trying to change scheduler name.

    Given I create a job with the name "job1"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I try to create a new trigger entity from the existing creator
    And I try to edit trigger name "schedule1"
    Then No exception was thrown

  Scenario: Update trigger definition
  Creating scheduler with proper properties. Trying to change trigger definition in scheduler.

    Given I create a job with the name "job1"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I set cron expression to "* * * ? * *"
    And I try to create a new trigger entity from the existing creator
    And I try to edit trigger definition to "Cron Job"
    Then No exception was thrown

  Scenario: Update scheduler start date
  Creating scheduler with proper properties. Trying to change start on date.

    Given I create a job with the name "job1"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And I try to create a new trigger entity from the existing creator
    And I try to edit start date to "13-12-2020" at "10:00"
    Then No exception was thrown

  Scenario: Update scheduler end date
  Creating scheduler with proper properties. Trying to change ends on date.

    Given I create a job with the name "job1"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And The trigger is set to end on "09-10-2018" at "6:00"
    And I try to create a new trigger entity from the existing creator
    And I try to edit end date to tomorrow at "10:00"
    Then No exception was thrown

  Scenario: Update schedule which doesn't exist
  Trying to update scheduler which doesn't exist.

    Given I create a job with the name "job1"
    And I expect the exception "NullPointerException" with the text "*"
    And I try to edit trigger name "schedule"
    Then An exception was thrown

  Scenario: Delete scheduler
  Trying to delete last created scheduler.

    Given I create a job with the name "job1"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And I try to create a new trigger entity from the existing creator
    And I try to delete last created trigger
    Then No exception was thrown

  Scenario: Delete scheduler which doesn't exist
  Trying to delete scheduler which doesn't exist.

    Given I create a job with the name "job1"
    And I expect the exception "NullPointerException" with the text "*"
    And I try to delete last created trigger
    Then An exception was thrown

@teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
