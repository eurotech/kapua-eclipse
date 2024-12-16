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
@jobsIntegration
@env_docker

Feature: JobEngineService execute job on device connect

  @setup
  Scenario: Setup test resources
    Given Init Security Context
    And Init Jaxb Context
    And Start Docker environment with resources
      | db                  |
      | events-broker       |
      | job-engine          |
      | message-broker      |
      | broker-auth-service |
      | consumer-lifecycle  |

  Scenario: Executing Job When Device Connected After The Specified Start Date And Time
  Login as the kapua-sys user and create a new job with a Command Execution job step.
  Define a new "Device Connect" schedule and add it to the created job.
  The schedule should have a start date in the past and no defined end date.
  Add a previously disconnected KuraMock device as the job target.
  After the restart of the KuraMock device the job should be started.
  The execution of the job should be confirmed, the job targets step index should be
  0 and status PROCESS_OK.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEATH"
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "TestSchedule1" is created
    And The trigger is set to start today at "00:00"
    Then I create a new trigger from the existing creator with previously defined date properties
    And I restart the Kura Mock
    And I wait 3 seconds
    When Device is connected within 10 seconds
    And I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_OK"
    When I search for events from device "rpione3" in account "kapua-sys" I find 4 events within 30 seconds
    And The type of the last event is "COMMAND"
    And I logout

  Scenario: Executing Job When Device Connected Before The Specified Start Date And Time
  Login as the kapua-sys user and create a new job with a Command Execution job step.
  Define a new "Device Connect" schedule and add it to the created job.
  The schedule should have a start date in the future and no defined end date.
  Add a previously disconnected KuraMock device as the job target.
  After the restart of the KuraMock device the job should not be started.
  No executions of the job should be found, the job targets step index should be
  0 and status PROCESS_AWAITING.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEATH"
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "TestSchedule2" is created
    And The trigger is set to start tomorrow at "06:00"
    Then I create a new trigger from the existing creator with previously defined date properties
    And I restart the Kura Mock
    And I wait 3 seconds
    When Device is connected within 10 seconds
    And I query for the job with the name "TestJob" and I count 0 execution item after 10 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_AWAITING"
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
    And The type of the last event is "BIRTH"
    And I logout

  Scenario: Executing Job When Device Connected Before End Date And Time
  Login as the kapua-sys user and create a new job with a Command Execution job step.
  Define a new "Device Connect" schedule and add it to the created job.
  The schedule should have start and end dates in the future.
  Add a previously disconnected KuraMock device as the job target.
  After the restart of the KuraMock device the job should be started.
  The execution of the job should be confirmed, the job targets step index should be
  0 and status PROCESS_OK.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEATH"
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "TestSchedule3" is created
    And The trigger is set to start today at "00:00"
    And The trigger is set to end tomorrow at "20:00"
    Then I create a new trigger from the existing creator with previously defined date properties
    And I restart the Kura Mock
    And I wait 3 seconds
    When Device is connected within 10 seconds
    And I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_OK"
    When I search for events from device "rpione3" in account "kapua-sys" I find 4 events within 30 seconds
    And The type of the last event is "COMMAND"
    And I logout

  Scenario: Executing Job When Device Connected After End Date And Time
  Login as the kapua-sys user and create a new job with a Command Execution job step.
  Define a new "Device Connect" schedule and add it to the created job.
  The schedule should have start and end dates in the past.
  Add a previously disconnected KuraMock device as the job target.
  After the KuraMock is reconnected the job should not be started.
  No executions of the job should be found, the job targets step index should be
  0 and status PROCESS_AWAITING.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEATH"
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "TestSchedule4" is created
    And The trigger is set to start today at "0:00"
    And The trigger is set to end in 10 seconds
    Then I create a new trigger from the existing creator with previously defined date properties
    And I wait 11 seconds
    And I restart the Kura Mock
    And I wait 3 seconds
    When Device is connected within 10 seconds
    And I query for the job with the name "TestJob" and I count 0 execution item after 10 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_AWAITING"
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
    And The type of the last event is "BIRTH"
    And I logout

  Scenario: Executing Job And Then Restarting Device
  Login as the kapua-sys user and create a new job with a Command Execution job step.
  Define a new "Device Connect" schedule and add it to the created job.
  The schedule should have a start date in the past and no defined end date.
  Add a previously disconnected KuraMock device as the job target.
  After the KuraMock is reconnected the job should be started.
  Another restart of the KuraMock the should not trigger another job execution.
  The previous execution of the job should be confirmed, and the job targets step
  index should be 0 and status PROCESS_OK.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEATH"
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "TestSchedule1" is created
    And The trigger is set to start today at "00:00"
    Then I create a new trigger from the existing creator with previously defined date properties
    And I restart the Kura Mock
    When Device is connected within 10 seconds
    And I wait 14 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 4 events within 30 seconds
    And The type of the last event is "COMMAND"
    Then KuraMock is disconnected
    And I wait 3 seconds
    When I restart the Kura Mock
    Then Device is connected within 10 seconds
    And I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_OK"
    When I search for events from device "rpione3" in account "kapua-sys" I find 6 events within 30 seconds
    And The type of the last event is "BIRTH"
    And I logout

  Scenario: Executing Job Without Steps
  Login as the kapua-sys user and create a new job without any steps defined.
  Create a new "Device Connect" schedule and add it to the created job.
  The schedule should have a start date in the past and no defined end date.
  Add a previously disconnected KuraMock device as the job target.
  After the KuraMock is restarted there should be no job executions found as
  there are no job steps defined.
  The job targets step index should be 0 and the status PROCESS_AWAITING.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEATH"
    Given I create a job with the name "TestJob"
    And A new job target item
    Then I find scheduler properties with name "Device Connect"
    And A regular trigger creator with the name "TestSchedule1" is created
    And The trigger is set to start today at "00:00"
    Then I create a new trigger from the existing creator with previously defined date properties
    And I restart the Kura Mock
    When Device is connected within 10 seconds
    And I wait 3 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
    And The type of the last event is "BIRTH"
    Then KuraMock is disconnected
    And I wait 3 seconds
    When I restart the Kura Mock
    Then Device is connected within 10 seconds
    And I query for the job with the name "TestJob" and I count 0 execution item after 10 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_AWAITING"
    When I search for events from device "rpione3" in account "kapua-sys" I find 5 events within 30 seconds
    And The type of the last event is "BIRTH"
    And I logout

  @teardown
  Scenario: Stop full docker environment
    Given Stop full docker environment
    And Clean Locator Instance
