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
@jobEngine
@jobEngineRestartOnlineDeviceSecondPart

Feature: JobEngineService restart job tests with online device - second part

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

  Scenario: Restarting a job with valid Configuration Put step two times
  Create a new job and set a connected KuraMock device as the job target.
  Add a new valid Configuration Put step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "5"
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "CONFIGURATION"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Configuration Put"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.clock.ClockService></id><properties><property name="clock.ntp.host" array="false" encrypted="false" type="String"><value>0.pool.ntp.org</value></property><property name="clock.provider" array="false" encrypted="false" type="String"><value>java-ntp</value></property><property name="clock.ntp.port" array="false" encrypted="false" type="Integer"><value>123</value></property><property name="clock.ntp.max-retry" array="false" encrypted="false" type="Integer"><value>0</value></property><property name="clock.ntp.refresh-interval" array="false" encrypted="false" type="Integer"><value>3600</value></property><property name="clock.set.hwclock" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="enabled" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="clock.ntp.timeout" array="false" encrypted="false" type="Integer"><value>10000</value></property><property name="clock.ntp.retry.interval" array="false" encrypted="false" type="Integer"><value>10</value></property></properties></configuration></configurations> |
      | timeout       | java.lang.Long                                                                | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    Then I create a new JobStep from the existing creator
    And I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    When I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    When I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "10"
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting a job with valid Package Install step two times
  Create a new job and set a connected KuraMock device as the job target.
  Add a new valid Package Install step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Packages are requested and 1 package is received
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "DEPLOY"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Package Download / Install"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                                            |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 30000                                                                                                                                                                                                                                                            |
    When I create a new JobStep from the existing creator
    And I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Then I query for the job with the name "TestJob" and I count 1 execution item or more and I confirm the executed job is finished within 20 seconds
    When I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Then I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    When Packages are requested and 2 packages are received
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting job With valid Asset Write step two times
  Create a new job and set a connected KuraMock device as the job target.
  Add a new valid Asset Write step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 123 are received
    When I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And The type of the last event is "ASSET"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And Search for step definition with the name "Asset Write"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name    | type                                                           | value                                                                                                                                                                                                                                     |
      | assets  | org.eclipse.kapua.service.device.management.asset.DeviceAssets | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>asset1</name><channels><channel><valueType>java.lang.Integer</valueType><value>1233</value><name>channel1</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout | java.lang.Long                                                 | 10000                                                                                                                                                                                                                                     |
    When I create a new JobStep from the existing creator
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 1233 are received
    Then KuraMock is disconnected
    And I logout

    # *******************************************************
    # * Restarting a job with one Target and multiple Steps *
    # *******************************************************

  Scenario: Restarting job with valid Configuration Put and Command Execution steps two times
  Create a new job. Set a connected Kura Mock device as a job target.
  Add a new valid Configuration Put and Command Execution steps to the created job. Restart the job two times.
  After the executed job is finished, the step index of executed targets should
  be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "5"
    And Command "pwd" is executed
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
    And The type of the last event is "COMMAND"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And I search for step definitions with the name
      | Configuration Put |
      | Command Execution |
    And I prepare a JobStepCreator with the name "TestStep1" and properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.clock.ClockService></id><properties><property name="clock.ntp.host" array="false" encrypted="false" type="String"><value>0.pool.ntp.org</value></property><property name="clock.provider" array="false" encrypted="false" type="String"><value>java-ntp</value></property><property name="clock.ntp.port" array="false" encrypted="false" type="Integer"><value>123</value></property><property name="clock.ntp.max-retry" array="false" encrypted="false" type="Integer"><value>0</value></property><property name="clock.ntp.refresh-interval" array="false" encrypted="false" type="Integer"><value>3600</value></property><property name="clock.set.hwclock" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="enabled" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="clock.ntp.timeout" array="false" encrypted="false" type="Integer"><value>10000</value></property><property name="clock.ntp.retry.interval" array="false" encrypted="false" type="Integer"><value>10</value></property></properties></configuration></configurations> |
      | commandInput  | org.eclipse.kapua.service.device.management.command.DeviceCommandInput        | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | timeout       | java.lang.Long                                                                | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    When I create multiple new JobSteps from the existing creators
    And No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item or more and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "10"
    When KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Package Uninstall and Asset Write steps two times
  Create a new job and set a connected KuraMock device as the job target.
  Add new valid Package Uninstall and valid Asset Write steps to the created job.
  Restart the job two times. After the executed job is finished, the executed target's
  step index should be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 123 are received
    And Packages are requested and 1 package is received
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
    And The type of the last event is "DEPLOY"
    Given I create a job with the name "TestJob"
    And I create a new job target item
    And I search for step definitions with the name
      | Package Uninstall |
      | Asset Write       |
    And I prepare a JobStepCreator with the name "TestStep1" and properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                                                     |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                    |
      | assets                  | org.eclipse.kapua.service.device.management.asset.DeviceAssets                                     | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>asset1</name><channels><channel><valueType>java.lang.Integer</valueType><value>1233</value><name>channel1</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                     |
    When I create multiple new JobSteps from the existing creators
    And No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution items or more and I confirm the executed jobs are finished within 45 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 3 or more events within 30 seconds
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 1233 are received
    And Packages are requested and 0 packages are received
    Then KuraMock is disconnected
    And I logout

    # *******************************************************
    # * Restarting a job with multiple Targets and one Step *
    # *******************************************************

  Scenario: Restarting a job with valid Configuration Put step and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job target.
  Add a new valid Configuration Put step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "5"
    And I search events from devices in account "kapua-sys" and 2 events is found
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Configuration Put"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.clock.ClockService></id><properties><property name="clock.ntp.host" array="false" encrypted="false" type="String"><value>0.pool.ntp.org</value></property><property name="clock.provider" array="false" encrypted="false" type="String"><value>java-ntp</value></property><property name="clock.ntp.port" array="false" encrypted="false" type="Integer"><value>123</value></property><property name="clock.ntp.max-retry" array="false" encrypted="false" type="Integer"><value>0</value></property><property name="clock.ntp.refresh-interval" array="false" encrypted="false" type="Integer"><value>3600</value></property><property name="clock.set.hwclock" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="enabled" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="clock.ntp.timeout" array="false" encrypted="false" type="Integer"><value>10000</value></property><property name="clock.ntp.retry.interval" array="false" encrypted="false" type="Integer"><value>10</value></property></properties></configuration></configurations> |
      | timeout       | java.lang.Long                                                                | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    When I create a new JobStep from the existing creator
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    And I search events from devices in account "kapua-sys" and 3 or more events are found
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "10"
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting a job with valid Package Install step and multiple devices two times
  Create a new job and set a connected KuraMock device as the job target. Add a new valid Package Install
  step to the created job. Restart the job two times. After the executed job is finished, the executed
  target's step index should be 0 and the status PROCESS_OK.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Packages are requested and 1 package is received
    And I search events from devices in account "kapua-sys" and 2 events is found
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Package Download / Install"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                                            |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 30000                                                                                                                                                                                                                                                            |
    When I create a new JobStep from the existing creator
    And I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Then I query for the job with the name "TestJob" and I count 1 execution items or more and I confirm the executed jobs are finished within 45 seconds
    When I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Then I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    And I search events from devices in account "kapua-sys" and 3 or more events is found
    When Packages are requested and 2 packages are received
    And KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Asset Write step and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new valid Asset Write step to the created job. Restart the job two times.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Devices status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 123 are received
    And I search events from devices in account "kapua-sys" and 2 events is found
    And The type of the last event is "ASSET"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And Search for step definition with the name "Asset Write"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name    | type                                                           | value                                                                                                                                                                                                                                     |
      | assets  | org.eclipse.kapua.service.device.management.asset.DeviceAssets | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>asset1</name><channels><channel><valueType>java.lang.Integer</valueType><value>1233</value><name>channel1</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout | java.lang.Long                                                 | 10000                                                                                                                                                                                                                                     |
    When I create a new JobStep from the existing creator
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    And I search events from devices in account "kapua-sys" and 3 or more events is found
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 1233 are received
    Then KuraMock is disconnected
    And I logout

    # *************************************************************
    # * Restarting a job with multiple Targets and multiple Steps *
    # *************************************************************

  Scenario: Restarting job with valid Configuration Put and Command Execution steps and multiple devices two times
  Create a new job. Set a connected Kura Mock devices as a job target.
  Add a new valid Configuration Put and Command Execution steps to the created job. Restart the job two times.
  After the executed job is finished, the step index of executed targets should
  be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    Then I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "5"
    And Command "pwd" is executed
    When I search events from devices in account "kapua-sys" and 3 events is found
    And The type of the last event is "COMMAND"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And I search for step definitions with the name
      | Configuration Put |
      | Command Execution |
    And I prepare a JobStepCreator with the name "TestStep1" and properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.clock.ClockService></id><properties><property name="clock.ntp.host" array="false" encrypted="false" type="String"><value>0.pool.ntp.org</value></property><property name="clock.provider" array="false" encrypted="false" type="String"><value>java-ntp</value></property><property name="clock.ntp.port" array="false" encrypted="false" type="Integer"><value>123</value></property><property name="clock.ntp.max-retry" array="false" encrypted="false" type="Integer"><value>0</value></property><property name="clock.ntp.refresh-interval" array="false" encrypted="false" type="Integer"><value>3600</value></property><property name="clock.set.hwclock" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="enabled" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="clock.ntp.timeout" array="false" encrypted="false" type="Integer"><value>10000</value></property><property name="clock.ntp.retry.interval" array="false" encrypted="false" type="Integer"><value>10</value></property></properties></configuration></configurations> |
      | commandInput  | org.eclipse.kapua.service.device.management.command.DeviceCommandInput        | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | timeout       | java.lang.Long                                                                | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
    When I create multiple new JobSteps from the existing creators
    And No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items and I confirm the executed jobs are finished within 45 seconds
    When I search events from devices in account "kapua-sys" and 3 or more events is found
    Then Configuration is requested
    And A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "10"
    When KuraMock is disconnected
    And I logout

  Scenario: Restarting job with valid Package Uninstall and Asset Write steps and multiple devices two times
  Create a new job and set a connected KuraMock devices as the job targets.
  Add a new valid Package Uninstall and valid Asset Write steps to the created job.
  Restart the job two times. After the executed job is finished, the executed target's
  step index should be 1 and the status PROCESS_OK

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Devices status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock devices after 5 seconds
    And Packages are requested and 1 package is received
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 123 are received
    When I search events from devices in account "kapua-sys" and 3 events is found
    And The type of the last event is "ASSET"
    Given I create a job with the name "TestJob"
    And I add targets to job
    And I search for step definitions with the name
      | Package Uninstall |
      | Asset Write       |
    And I prepare a JobStepCreator with the name "TestStep1" and properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                                                     |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                    |
      | assets                  | org.eclipse.kapua.service.device.management.asset.DeviceAssets                                     | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>asset1</name><channels><channel><valueType>java.lang.Integer</valueType><value>1233</value><name>channel1</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                     |
    When I create multiple new JobSteps from the existing creators
    And No exception was thrown
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution items or more and I confirm the executed jobs are finished within 45 seconds
    Then I restart a job
    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
    Given I query for the job with the name "TestJob" and I count 2 execution items or more and I confirm the executed jobs are finished within 45 seconds
    When I search events from devices in account "kapua-sys" and 3 or more events is found
    And Device assets are requested
    And Asset with name "asset1" and channel with name "channel1" and value 1233 are received
    And Packages are requested and 0 packages are received
    Then KuraMock is disconnected
    And I logout

  @teardown
  Scenario: Stop full docker environment
    Given Stop full docker environment
    And Clean Locator Instance
