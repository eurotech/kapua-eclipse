###############################################################################
# Copyright (c) 2019, 2024 Eurotech and/or its affiliates and others
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
@env_docker
@it
@jobEngine
@jobEngineRestartOnlineDevice

Feature: JobEngineService restart job tests with online device

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

    # *************************************************
    # * Restarting a job with one Target and one Step *
    # *************************************************

  Scenario: Restarting job with valid Command Execution step two times
  Create a new job and set a connected KuraMock device as the job target.
  Add a new valid Command Execution step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 1 event within 30 seconds
    And The type of the last event is "BIRTH"
    And I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    And I create a new JobStep from the existing creator
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    And I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 or more events within 30 seconds
    Then KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Bundle Start step two times
  Create a new job and set a connected KuraMock device as the job target.
  Add a new Bundle Start step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "BUNDLE"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "ACTIVE"
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Bundle Stop step two times
  Create a new job and set a connected KuraMock device as the job target.
  Add a new valid Bundle Stop step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "BUNDLE"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 77    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    Then Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "RESOLVED"
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting a job with valid Package Uninstall step two times
  Create a new job and set a connected KuraMock device as the job target.
  Add a new valid Package Uninstall step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Then Packages are requested and 1 package is received
    And I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEPLOY"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Package Uninstall"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                  |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest> |
      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                  |
    When I create a new JobStep from the existing creator
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution items or more and I confirm the executed jobs are finished within 45 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    And I search for events from device "rpione3" in account "kapua-sys" I find 2 or more events within 30 seconds
    Then Packages are requested and 0 packages are received
    And KuraMock is disconnected
    And I logout

     #*******************************************************
     #* Restarting a job with one Target and multiple Steps *
     #*******************************************************

  Scenario: Restarting job with valid Command Execution and Package Install steps two times
  Create a new job and set a connected KuraMock device as the job target.
  Add new valid Command Execution and valid Package Install steps to the created job.
  Restart the job two times. After the executed job is finished, the executed target's
  step index should be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Command "pwd" is executed
    And Packages are requested and 1 package is received
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
    And The type of the last event is "DEPLOY"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And I search for step definition with the name
      | Command Execution          |
      | Package Download / Install |
    And I prepare a JobStepCreator with the name "TestStep1" and properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                                            |
      | commandInput           | org.eclipse.kapua.service.device.management.command.DeviceCommandInput                           | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput>                                                                                                                    |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                                            |
    And I create multiple new JobSteps from the existing creators
    Then No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution items or more and I confirm the executed jobs are finished within 45 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    Then KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Bundle Start And Bundle Stop steps two times
  Create a new job and set a connected KuraMock device as the job target.
  Add new Bundle Start and Bundle Stop steps to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    And Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "BUNDLE"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 77    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 4 or more events within 30 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "ACTIVE"
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "RESOLVED"
    And KuraMock is disconnected
    And I logout

     #*******************************************************
     #* Restarting a job with multiple Targets and one Step *
     #*******************************************************

  Scenario: Restarting job with valid Command Execution step and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new valid Command Execution step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Devices status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Command "pwd" is executed
    When I search events from devices in account "kapua-sys" and 2 events are found
    And The type of the last event is "COMMAND"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    And I create a new JobStep from the existing creator
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search events from devices in account "kapua-sys" and 3 or more events are found
    Then KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Bundle Start step and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new Bundle Start step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When I search events from devices in account "kapua-sys" and 2 events are found
    And The type of the last event is "BUNDLE"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search events from devices in account "kapua-sys" and 3 or more events are found
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "ACTIVE"
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Bundle Stop step and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new valid Bundle Stop step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    When I search events from devices in account "kapua-sys" and 2 events are found
    And The type of the last event is "BUNDLE"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 77    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search events from devices in account "kapua-sys" and 3 or more events are found
    Then Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "RESOLVED"
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting a job with valid Package Uninstall step and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new valid Package Uninstall step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And I wait 1 second
    Then Devices status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Then Packages are requested and 1 package is received
    And I search events from devices in account "kapua-sys" and 2 events are found
    And The type of the last event is "DEPLOY"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Package Uninstall"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                  |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest> |
      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                  |
    When I create a new JobStep from the existing creator
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution items or more and I confirm the executed jobs are finished within 45 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    And I search events from devices in account "kapua-sys" and 2 or more events are found
    And Packages are requested and 0 packages are received
    And KuraMock is disconnected
    And I logout

    # *************************************************************
    # * Restarting a job with multiple Targets and multiple Steps *
    # *************************************************************

  Scenario: Restarting job with valid Command Execution and Package Install steps and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new valid Command Execution and valid Package Install steps to the created job.
  Restart the job two times. After the executed job is finished, the executed target's
  step index should be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Devices status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Command "pwd" is executed
    And Packages are requested and 1 package is received
    When I search events from devices in account "kapua-sys" and 3 events are found
    And The type of the last event is "DEPLOY"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And I search for step definition with the name
      | Command Execution          |
      | Package Download / Install |
    And I prepare a JobStepCreator with the name "TestStep1" and properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                                            |
      | commandInput           | org.eclipse.kapua.service.device.management.command.DeviceCommandInput                           | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput>                                                                                                                    |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                                            |
    And I create multiple new JobSteps from the existing creators
    Then No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution items or more and I confirm the executed jobs are finished within 45 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    When I search events from devices in account "kapua-sys" and 3 or more events are found
    And Packages are requested and 2 packages are received
    Then KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Bundle Start and Bundle Stop steps and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new valid Bundle Start and Bundle Stop steps to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And I wait 1 second
    Then Devices status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    When I search events from devices in account "kapua-sys" and 2 events are found
    And The type of the last event is "BUNDLE"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 77    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search events from devices in account "kapua-sys" and 4 or more events are found
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "ACTIVE"
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "RESOLVED"
    And KuraMock is disconnected
    And I logout

  @teardown
  Scenario: Tear down test resources
    Given Stop Docker environment
    And Clean Locator Instance
