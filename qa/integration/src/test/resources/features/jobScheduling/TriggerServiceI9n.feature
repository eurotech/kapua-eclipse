###############################################################################
# Copyright (c) 2019, 2022 Eurotech and/or its affiliates and others
#
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#     Eurotech - initial API and implementation
###############################################################################
@env_docker_base
@jobsIntegration

Feature: Trigger service tests

  @setup
  Scenario: Setup test resources
    Given Init Security Context
    And Init Jaxb Context
    And Start Docker environment with resources
      | db                  |
      | events-broker       |
      | job-engine          |

  Scenario: Adding "Device Connect" Schedule With All Valid Parameters
  Login as kapua-sys user and create a job with name job0.
  Add schedule0 with a valid start date to the created job.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout

    # ***********************
    # * Schedule Name Tests *
    # ***********************

  Scenario: Adding "Device Connect" Schedule Without Name
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule with a valid start date but
  without defining its name. A KapuaIllegalNullArgumentException
  should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "" is created
    And The trigger is set to start today at "10:00"
    When I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown
    And I logout

  Scenario: Adding "Device Connect" Schedule With Name Only
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule0, without defining any other property
  except the schedule name. A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    When I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown
    And I logout

  Scenario: Adding "Device Connect" Schedule With Non-Unique Name
  Login as kapua-sys user and create a job with name job0.
  Add schedule1 to the created job. After the schedule1 is added
  successfully try to add a new schedule with the same name.
  A KapuaDuplicateNameException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start today at "0:00"
    And The trigger is set to start today at "23:59"
    And I create a new trigger from the existing creator with previously defined date properties
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start today at "12:00"
    When I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name schedule1 already exists"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown
    And I logout

  Scenario: Adding "Device Connect" Schedule With Max Length Name
  Login as kapua-sys user and create a job with name job0.
  Add a new schedule with 255 character long name.
  As this is the defined limit for the max number of characters
  for the schedule name, no errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww" is created
    And The trigger is set to start today at "10:00"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout

  Scenario: Adding "Device Connect" Schedule With Min Length Name
  Login as kapua-sys user and create a job with name job0.
  Add a new schedule with three character long name.
  As this is the defined limit for the min number of characters
  for the schedule name, no errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "www" is created
    And The trigger is set to start today at "10:00"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout

    # *****************************
    # * Schedule Start Date Tests *
    # *****************************

  Scenario: Adding "Device Connect" Schedule Without The Start Date Parameter
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule0 without passing the value for start date property.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Device Connect" Schedule With Non-Unique Start Date Parameter
  Login as kapua-sys user and create a job with name job0.
  Create a new schedule0 with a specific start date parameter.
  Try to create a new schedule1 with the same start date parameter.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And I create a new trigger from the existing creator with previously defined date properties
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout

  Scenario: Adding "Device Connect" Schedule With Start Date Only
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule with a defined start date but
  without setting the name parameter.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

    # ***************************
    # * Schedule End Date Tests *
    # ***************************

  Scenario: Adding "Device Connect" Schedule With Non-Unique End Date Parameter
  Login as kapua-sys user and create a job with name job0.
  Create a new schedule0 with specific start and end date parameters.
  Try to create a new schedule1 with the same end date parameter.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    Then A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-01-2030" at "10:10"
    And The trigger is set to end on "15-12-2030" at "10:10"
    Then I create a new trigger from the existing creator with previously defined date properties
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start on "12-12-2030" at "10:10"
    And The trigger is set to end on "15-12-2030" at "10:10"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout

  Scenario: Adding "Device Connect" Schedule With End Date Only
  Login as kapua-sys user and create a job with name job0.
  Try to create a schedule without defining any other property except the end date.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "" is created
    And The trigger is set to end on "12-12-2020" at "10:10"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

    # *************************************************
    # * Schedule Start And Stop Date Comparison Tests *
    # *************************************************

  Scenario: Adding "Device Connect" Schedule With End Time before Start time
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule0 with start date later than the end date.
  A KapuaEndBeforeStartTimeException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "11:00"
    And The trigger is set to end on "12-12-2020" at "10:00"
    When I expect the exception "TriggerInvalidDatesException" with the text "Trigger with given startsOn and endsOn will never fire according to the current date"
    And I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Device Connect" Schedule With the same Start and End time
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule0 with start date the same as the end date.
  A KapuaException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:00"
    And The trigger is set to end on "12-12-2020" at "10:00"
    When I expect the exception "TriggerInvalidDatesException" with the text "Trigger with given startsOn and endsOn will never fire according to the current date"
    And I create a new trigger from the existing creator with previously defined date properties
    And  An exception was thrown
    And I logout

    #  ******************
    #   * INTERVAL JOB *
    #  ******************

  Scenario: Adding "Interval Job" Schedule With All Valid Parameters
  Login as kapua-sys user and create a job with name "job0".
  Add "schedule0" with a valid start date to the created job.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to 1
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

    # ************************
    # * Schedule Name Tests *
    # ************************

  Scenario: Adding "Interval Job" Schedule Without a Name
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule with a valid start date but
  without defining its name. A KapuaIllegalNullArgumentException
  should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to 1
    When I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown
    And I logout

  Scenario: Adding "Interval Job" Schedule With Name Only
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0", without defining any other property except the schedule name.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And I set retry interval to 1
    When I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown
    And I logout

  Scenario: Adding "Interval Job" Schedule With Non-Unique Name
  Login as kapua-sys user and create a job with name "job0".
  Add "schedule1" to the created job.
  After the "schedule1" is added successfully, try to add a new schedule with the same name.
  A KapuaDuplicateNameException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to 1
    And I create a new trigger from the existing creator with previously defined date properties
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start today at "12:00"
    And I set retry interval to 1
    When I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name schedule1 already exists"
    And I create a new trigger from the existing creator with previously defined date properties
    Then An exception was thrown
    And I logout

  Scenario: Adding "Interval Job" Schedule With Max Length Name
  Login as kapua-sys user and create a job with name "job0".
  Add a new schedule with 255 character long name.
  As this is the defined limit for the max number of characters for the schedule name, no errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to 1
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

  Scenario: Interval Job" Schedule With Too Long Name
  Login as kapua-sys user and create a job with name "job0".
  Add a new schedule with 256 character long name.
  An error should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to 1
    Given I expect the exception "KapuaIllegalArgumentException" with the text " Value over than allowed max length. Max length is: 255."
    And I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Interval Job" Schedule With Min Length Name
  Login as kapua-sys user and create a job with name "job0".
  Add a new schedule with one character long name.
  As this is the defined limit for the min number of characters for the schedule name, no errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "www" is created
    And The trigger is set to start today at "10:00"
    And I set retry interval to 1
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

    # *****************************
    # * Schedule Start Date Tests *
    # *****************************

  Scenario: Adding "Interval Job" Schedule Without The Start Date Parameter
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" without passing the value for start date property.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Interval Job" Schedule With Non-Unique Start Date Parameter
  Login as kapua-sys user and create a job with name "job0".
  Create a new "schedule0" with a specific start date parameter.
  Try to create a new "schedule1" with the same start date parameter.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And I set retry interval to 1
    And I create a new trigger from the existing creator with previously defined date properties
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And I set retry interval to 1
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

  Scenario: Adding "Interval Job" Schedule With Start Date Only
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new schedule with a defined start date but without setting the name parameter.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    And I set retry interval to 1
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

    # ***************************
    # * Schedule End Date Tests *
    # ***************************

  Scenario: Adding "Interval Job" Schedule With Non-Unique End Date Parameter
  Login as kapua-sys user and create a job with name "job0".
  Create a new "schedule0" with specific start and end date parameters.
  Try to create a new "schedule1" with the same end date parameter.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    Then A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-01-2030" at "10:10"
    And The trigger is set to end on "15-12-2030" at "10:10"
    And I set retry interval to 1
    Then I create a new trigger from the existing creator with previously defined date properties
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start on "12-12-2030" at "10:10"
    And The trigger is set to end on "15-12-2030" at "10:10"
    And I set retry interval to 1
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

  Scenario: Adding "Interval Job" Schedule With End Date Only
  Login as kapua-sys user and create a job with name "job0".
  Try to create a schedule without defining any other property except the end date.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "" is created
    And The trigger is set to end on "12-12-2020" at "10:10"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  # *************************************************
  # * Schedule Start And Stop Date Comparison Tests *
  # *************************************************

  Scenario: Adding "Interval Job" Schedule With End Time before Start time
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" with start date later than the end date.
  A KapuaEndBeforeStartTimeException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "11:00"
    And The trigger is set to end on "12-12-2020" at "10:00"
    Then I set retry interval to 1
    When I expect the exception "TriggerInvalidDatesException" with the text "Trigger with given startsOn and endsOn will never fire according to the current date"
    And I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Interval Job" Schedule With the same Start and End time
  Login as kapua-sys user and create a job with name job0.
  Try to create a new schedule0 with start date the same as the end date.
  A KapuaException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:00"
    And The trigger is set to end on "12-12-2020" at "10:00"
    Then I set retry interval to 1
    When I expect the exception "TriggerInvalidDatesException" with the text "Trigger with given startsOn and endsOn will never fire according to the current date"
    And I create a new trigger from the existing creator with previously defined date properties
    And  An exception was thrown
    And I logout

    # **********************************
    # * Schedule Interval Number Tests *
    # **********************************

  Scenario: Adding "Interval Job" Schedule With Null Interval Number
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" with null interval number.
  A KapuaException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "0:00"
    And The trigger is set to end tomorrow at "10:00"
    Then I set retry interval to null
    When I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided for the argument interval"
    And I create a new trigger from the existing creator with previously defined date properties
    And  An exception was thrown
    And I logout

  Scenario: Adding "Interval Job" Schedule Without Interval Number
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" without interval number.
  A KapuaException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "0:00"
    And The trigger is set to end tomorrow at "10:00"
    When I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided for the argument interval"
    And I create a new trigger from the existing creator with previously defined date properties
    And  An exception was thrown
    And I logout

    #  ************
    #  * CRON JOB *
    #  ************

  Scenario: Adding "Cron Job" Schedule With All Valid Parameters
  Login as kapua-sys user and create a job with name "job0".
  Add "schedule0" with a valid start date to the created job.
  No errors should be thrown. (e.g execute at 10:15 every day)

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    Then I set cron expression to "0 15 10 * * ?"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

  Scenario: Adding "Cron Job" Schedule With All Valid Parameters Except Cron Format
  Login as kapua-sys user and create a job with name "job0".
  Add "schedule0" with a valid start date to the created job.
  An errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    Then I set cron expression to "1"
    And I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument cronExpression"
    And I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Cron Job" Schedule With All Valid Parameters And Null Cron Value
  Login as kapua-sys user and create a job with name "job0".
  Add "schedule0" with a valid start date to the created job.
  An errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided for the argument cronExpression"
    And I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

    # *****************************
    # * Schedule Start Date Tests *
    # *****************************

  Scenario: Adding "Cron Job" Schedule Without The Start Date Parameter
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" without passing the value for start date property.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    Then I set cron expression to "0 15 10 * * ?"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Cron Job" Schedule With Non-Unique Start Date Parameter
  Login as kapua-sys user and create a job with name "job0".
  Create a new "schedule0" with a specific start date parameter.
  Try to create a new schedule1 with the same start date parameter.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    Then I set cron expression to "0 15 10 * * ?"
    And I create a new trigger from the existing creator with previously defined date properties
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    Then I set cron expression to "0 15 15 * * ?"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

  Scenario: Adding "Cron Job" Schedule With Start Date Only
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new schedule with a defined start date but without setting the name parameter.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "" is created
    And The trigger is set to start on "12-12-2020" at "10:10"
    Then I set cron expression to "0 15 15 * * ?"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

    # ***************************
    # * Schedule End Date Tests *
    # ***************************

  Scenario: Adding "Cron Job" Schedule With Non-Unique End Date Parameter
  Login as kapua-sys user and create a job with name "job0".
  Create a new "schedule0" with specific start and end date parameters.
  Try to create a new "schedule1" with the same end date parameter.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    Then A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-01-2030" at "10:10"
    And The trigger is set to end on "15-12-2030" at "10:10"
    Then I set cron expression to "0 15 15 * * ?"
    Then I create a new trigger from the existing creator with previously defined date properties
    And A regular trigger creator with the name "schedule1" is created
    And The trigger is set to start on "12-12-2030" at "10:10"
    And The trigger is set to end on "15-12-2030" at "10:10"
    Then I set cron expression to "0 15 15 * * ?"
    And I create a new trigger from the existing creator with previously defined date properties
    And I logout
    Then No exception was thrown

  Scenario: Adding "Cron Job" Schedule With End Date Only
  Login as kapua-sys user and create a job with name "job0".
  Try to create a schedule without defining any other property except the end date.
  A KapuaIllegalNullArgumentException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "" is created
    And The trigger is set to end on "12-12-2020" at "10:10"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout


    # *************************************************
    # * Schedule Start And Stop Date Comparison Tests *
    # *************************************************

  Scenario: Adding "Cron Job" Schedule With End Time before Start time
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" with start date later than the end date.
  A KapuaEndBeforeStartTimeException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "12:00"
    And The trigger is set to end on "10-12-2020" at "10:00"
    Then I set cron expression to "0 15 10 * * ?"
    When I expect the exception "TriggerInvalidDatesException" with the text "Trigger with given startsOn and endsOn will never fire according to the current date"
    And I create a new trigger from the existing creator with previously defined date properties
    And An exception was thrown
    And I logout

  Scenario: Adding "Cron Job" Schedule With the same Start and End time
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" with start date the same as the end date.
  A KapuaException should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:00"
    And The trigger is set to end on "12-12-2020" at "10:00"
    Then I set cron expression to "0 15 10 * * ?"
    When I expect the exception "TriggerInvalidDatesException" with the text "Trigger with given startsOn and endsOn will never fire according to the current date"
    And I create a new trigger from the existing creator with previously defined date properties
    And  An exception was thrown
    And I logout

    # ************************************
    # * Interval Triggering Delete Tests *
    # ************************************

  Scenario: Deleting "Interval Schedule" Triggering
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" with all valid parameters and delete it.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:00"
    And The trigger is set to end tomorrow at "10:00"
    Then I set retry interval to 2
    And I create a new trigger from the existing creator with previously defined date properties
    Then I delete trigger with name "schedule0"
    And I search for the trigger with name "schedule0" in the database
    And There is no trigger with the name "schedule0" in the database
    Then I logout

    # ********************************
    # * Cron Triggering Delete Tests *
    # ********************************

  Scenario: Deleting "Cron Schedule" Triggering
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" with all valid parameters and delete it.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Cron Job"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start on "12-12-2020" at "10:00"
    And The trigger is set to end tomorrow at "20:00"
    Then I set cron expression to "0 15 10 * * ?"
    And I create a new trigger from the existing creator with previously defined date properties
    Then I delete trigger with name "schedule0"
    And I search for the trigger with name "schedule0" in the database
    And There is no trigger with the name "schedule0" in the database
    Then I logout

    # **********************************
    # * Device Triggering Delete Tests *
    # **********************************

  Scenario: Deleting "Device Schedule" Triggering
  Login as kapua-sys user and create a job with name "job0".
  Try to create a new "schedule0" with all valid parameters and delete it.
  No errors should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I create a job with the name "job0"
    When I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "schedule0" is created
    And The trigger is set to start today at "10:00"
    And I create a new trigger from the existing creator with previously defined date properties
    Then I delete trigger with name "schedule0"
    And I search for the trigger with name "schedule0" in the database
    And There is no trigger with the name "schedule0" in the database
    Then I logout

  @teardown
  Scenario: Stop test environment
    Given Stop full docker environment
    And Clean Locator Instance
    And Reset Security Context
