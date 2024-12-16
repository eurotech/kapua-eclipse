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
@jobEngineStartOfflineDevice

Feature: JobEngineService tests for starting job with offline device

  @setup
  Scenario: Setup test resources
    Given Init Security Context
    And Start Docker environment with resources
      | db                  |
      | events-broker       |
      | job-engine          |
      | message-broker      |
      | broker-auth-service |
      | consumer-lifecycle  |

    # ***********************************************
    # * Starting a job with one Target and one Step *
    # ***********************************************

  Scenario: Starting a job with Command Execution step
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Command Execution step to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting a job with Asset Write step
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Asset Write step to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Asset Write"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name    | type                                                           | value                                                                                                                                                                                                                                                   |
      | assets  | org.eclipse.kapua.service.device.management.asset.DeviceAssets | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>assetName</name><channels><channel><valueType>binary</valueType><value>EGVzdCBzdHJpbmcgdmFsdWU=</value><name>binaryTest</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout | java.lang.Long                                                 | 10000                                                                                                                                                                                                                                                   |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting a job with Bundle Start step
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Bundle Start step to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Bundle Stop step
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Bundle Stop step to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 77    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Configuration Put step
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Configuration Put step to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Configuration Put"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.demo.heater.Heater</id><properties><property name="temperature.increment" array="false" encrypted="false" type="Float"><value>0.25</value></property><property name="publish.rate" array="false" encrypted="false" type="Integer"><value>60</value></property><property name="program.stopTime" array="false" encrypted="false" type="String"><value>22:00</value></property><property name="publish.retain" array="false" encrypted="false" type="Boolean"><value>false</value></property><property name="service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="kura.service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="program.startTime" array="false" encrypted="false" type="String"><value>06:00</value></property><property name="mode" array="false" encrypted="false" type="String"><value>Program</value></property><property name="publish.semanticTopic" array="false" encrypted="false" type="String"><value>data/210</value></property><property name="manual.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property><property name="publish.qos" array="false" encrypted="false" type="Integer"><value>2</value></property><property name="temperature.initial" array="false" encrypted="false" type="Float"><value>13.0</value></property><property name="program.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property></properties></configuration></configurations> |
      | timeout       | java.lang.Long                                                                | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting a job with Package Install step
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Package Install step to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Packages are requested and 1 package is received
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Package Download / Install"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                           |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.demo.heater_1.0.300.dp</uri><name>heater</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                           |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Packages are requested and 1 package is received
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Package Uninstall step
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Package Uninstall step to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Packages are requested and 1 package is received
    And Package named "org.eclipse.kura.example.beacon" with version "1.0.300" is received
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Package Uninstall"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                  |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest> |
      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                  |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Packages are requested and 1 package is received
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

    # *****************************************************
    # * Starting a job with one Target and multiple Steps *
    # *****************************************************

  Scenario: Starting a job with Command Execution and Bundle Start steps
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Command Execution and Bundle Stop steps to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 10000                                                                                                                                         |
    And I create a new JobStep from the existing creator
    Then Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Asset Write and Bundle Start steps
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Asset Write and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Asset Write"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name    | type                                                           | value                                                                                                                                                                                                                                                   |
      | assets  | org.eclipse.kapua.service.device.management.asset.DeviceAssets | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>assetName</name><channels><channel><valueType>binary</valueType><value>EGVzdCBzdHJpbmcgdmFsdWU=</value><name>binaryTest</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout | java.lang.Long                                                 | 10000                                                                                                                                                                                                                                                   |
    And I create a new JobStep from the existing creator
    Then Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with two Bundle Start steps
  Create a new job and set a disconnected KuraMock device as the job target.
  Add two new Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    And A bundle named "com.google.guava" with id 95 and version "19.0.0" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    And I create a new JobStep from the existing creator
    Then Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 95    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I start a job
    And I wait 10 seconds
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Bundles are requested
    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    And A bundle named "com.google.guava" with id 95 and version "19.0.0" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Bundle Stop and Bundle Start steps
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Bundle Stop and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    And A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 77    |
      | timeout  | java.lang.Long   | 10000 |
    And I create a new JobStep from the existing creator
    Then Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Bundles are requested
    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
    And A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Configuration Put and Bundle Start steps
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Configuration Put and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Bundles are requested
    And A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Configuration Put"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.demo.heater.Heater</id><properties><property name="temperature.increment" array="false" encrypted="false" type="Float"><value>0.25</value></property><property name="publish.rate" array="false" encrypted="false" type="Integer"><value>60</value></property><property name="program.stopTime" array="false" encrypted="false" type="String"><value>22:00</value></property><property name="publish.retain" array="false" encrypted="false" type="Boolean"><value>false</value></property><property name="service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="kura.service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="program.startTime" array="false" encrypted="false" type="String"><value>06:00</value></property><property name="mode" array="false" encrypted="false" type="String"><value>Program</value></property><property name="publish.semanticTopic" array="false" encrypted="false" type="String"><value>data/210</value></property><property name="manual.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property><property name="publish.qos" array="false" encrypted="false" type="Integer"><value>2</value></property><property name="temperature.initial" array="false" encrypted="false" type="Float"><value>13.0</value></property><property name="program.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property></properties></configuration></configurations> |
      | timeout       | java.lang.Long                                                                | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
    When I create a new JobStep from the existing creator
    Then Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    And I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Bundles are requested
    And A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Package Install and Bundle Start steps
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Package Install and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Packages are requested and 1 package is received
    And Bundles are requested
    And A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Package Download / Install"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                           |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.demo.heater_1.0.300.dp</uri><name>heater</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                           |
    And I create a new JobStep from the existing creator
    Then Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Packages are requested and 1 package is received
    And Bundles are requested
    And A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    And Device status is "DISCONNECTED" within 10 seconds
    And I logout

  Scenario: Starting a job with Package Uninstall and Bundle Start steps
  Create a new job and set a disconnected KuraMock device as the job target.
  Add a new Package Uninstall and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the executed target's step index should
  be 0 and the status PROCESS_FAILED.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Packages are requested and 1 package is received
    And Package named "org.eclipse.kura.example.beacon" with version "1.0.300" is received
    And Bundles are requested
    And A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And A new job target item
    And Search for step definition with the name "Package Uninstall"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                  |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest> |
      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                  |
    And I create a new JobStep from the existing creator
    Then Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 34    |
      | timeout  | java.lang.Long   | 10000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    When I start the Kura Mock
    And Device is connected within 10 seconds
    And Packages are requested and 1 package is received
    And KuraMock is disconnected
    And I logout

    # *****************************************************
    # * Starting a job with multiple Targets and one Step *
    # *****************************************************

  Scenario: Starting job with Bundle Start step and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Bundle Start step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 136   |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    And I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Bundle Stop step and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Bundle Stop step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 136   |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Package Download/Install step and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Package Install step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Packages are requested and 1 package is received
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Package Download / Install"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                           |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.demo.heater_1.0.300.dp</uri><name>heater</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                           |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And Packages are requested
    Then Number of received packages is 1
    And KuraMock is disconnected
    And I logout

  Scenario: Starting job with Package Uninstall step and multiple device
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Package Uninstall step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Package Uninstall"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                  |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest> |
      | timeout                 | java.lang.Long                                                                                     | 30000                                                                                                                                                                                                  |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Asset Write step and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Asset Write step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Asset Write"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name    | type                                                           | value                                                                                                                                                                                                                                                   |
      | assets  | org.eclipse.kapua.service.device.management.asset.DeviceAssets | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>assetName</name><channels><channel><valueType>binary</valueType><value>EGVzdCBzdHJpbmcgdmFsdWU=</value><name>binaryTest</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout | java.lang.Long                                                 | 50000                                                                                                                                                                                                                                                   |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Configuration Put step and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Configuration Put step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Configuration Put"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.demo.heater.Heater</id><properties><property name="temperature.increment" array="false" encrypted="false" type="Float"><value>0.25</value></property><property name="publish.rate" array="false" encrypted="false" type="Integer"><value>60</value></property><property name="program.stopTime" array="false" encrypted="false" type="String"><value>22:00</value></property><property name="publish.retain" array="false" encrypted="false" type="Boolean"><value>false</value></property><property name="service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="kura.service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="program.startTime" array="false" encrypted="false" type="String"><value>06:00</value></property><property name="mode" array="false" encrypted="false" type="String"><value>Program</value></property><property name="publish.semanticTopic" array="false" encrypted="false" type="String"><value>data/210</value></property><property name="manual.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property><property name="publish.qos" array="false" encrypted="false" type="Integer"><value>2</value></property><property name="temperature.initial" array="false" encrypted="false" type="Float"><value>13.0</value></property><property name="program.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property></properties></configuration></configurations> |
      | timeout       | java.lang.Long                                                                | 50000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Command Execution step and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Command Execution step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 50000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

    # ***********************************************************
    # * Starting a job with multiple Targets and multiple Steps *
    # ***********************************************************

  Scenario: Starting job with two Bundle Start steps and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a two Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 136   |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 36    |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Bundle Stop and Bundle Start step and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Bundle Stop and Bundle Start step to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I wait 1 second
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Bundle Stop"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 136   |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 36    |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Package Download/Install and Bundle Start steps and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Package Install and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    And Packages are requested and 1 package is received
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Package Download / Install"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                           |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.demo.heater_1.0.300.dp</uri><name>heater</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                           |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 36    |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I add 2 devices to Kura Mock
    And Devices are connected within 10 seconds
    And Packages are requested
    Then Number of received packages is 1
    And Bundles are requested
    And I logout

  Scenario: Starting job with Package Uninstall and Bundle start steps and multiple device
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Package Uninstall and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Package Uninstall"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name                    | type                                                                                               | value                                                                                                                                                                                                  |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest> |
      | timeout                 | java.lang.Long                                                                                     | 30000                                                                                                                                                                                                  |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 36    |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Asset Write and Bundle Start steps and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Asset Write and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Asset Write"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name    | type                                                           | value                                                                                                                                                                                                                                                   |
      | assets  | org.eclipse.kapua.service.device.management.asset.DeviceAssets | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>assetName</name><channels><channel><valueType>binary</valueType><value>EGVzdCBzdHJpbmcgdmFsdWU=</value><name>binaryTest</name></channel></channels></deviceAsset></deviceAssets> |
      | timeout | java.lang.Long                                                 | 50000                                                                                                                                                                                                                                                   |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 36    |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Configuration Put and Bundle Start steps and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Configuration Put and BundleStart steps to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Configuration Put"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name          | type                                                                          | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | configuration | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.demo.heater.Heater</id><properties><property name="temperature.increment" array="false" encrypted="false" type="Float"><value>0.25</value></property><property name="publish.rate" array="false" encrypted="false" type="Integer"><value>60</value></property><property name="program.stopTime" array="false" encrypted="false" type="String"><value>22:00</value></property><property name="publish.retain" array="false" encrypted="false" type="Boolean"><value>false</value></property><property name="service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="kura.service.pid" array="false" encrypted="false" type="String"><value>org.eclipse.kura.demo.heater.Heater</value></property><property name="program.startTime" array="false" encrypted="false" type="String"><value>06:00</value></property><property name="mode" array="false" encrypted="false" type="String"><value>Program</value></property><property name="publish.semanticTopic" array="false" encrypted="false" type="String"><value>data/210</value></property><property name="manual.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property><property name="publish.qos" array="false" encrypted="false" type="Integer"><value>2</value></property><property name="temperature.initial" array="false" encrypted="false" type="Float"><value>13.0</value></property><property name="program.setPoint" array="false" encrypted="false" type="Float"><value>30.0</value></property></properties></configuration></configurations> |
      | timeout       | java.lang.Long                                                                | 50000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 36    |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  Scenario: Starting job with Command Execution and Bundle Start steps and multiple devices
  Create a new job. Set a disconnected Kura Mock devices as a job targets.
  Add a new Command Execution and Bundle Start steps to the created job. Start the job.
  After the executed job is finished, the step index of executed targets should
  be 0 and the status PROCESS_FAILED

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I add 2 devices to Kura Mock
    When Devices are connected within 10 seconds
    And I wait 1 second
    Then Device status is "CONNECTED" within 10 seconds
    When KuraMock is disconnected
    And I wait 1 second
    Then Device status is "DISCONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    Given I create a job with the name "TestJob"
    And I add targets to job
    When I count the targets in the current scope
    Then I count 2
    And Search for step definition with the name "Command Execution"
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name         | type                                                                   | value                                                                                                                                         |
      | commandInput | org.eclipse.kapua.service.device.management.command.DeviceCommandInput | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput> |
      | timeout      | java.lang.Long                                                         | 50000                                                                                                                                         |
    When I create a new JobStep from the existing creator
    And Search for step definition with the name "Bundle Start"
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name     | type             | value |
      | bundleId | java.lang.String | 36    |
      | timeout  | java.lang.Long   | 50000 |
    When I create a new JobStep from the existing creator
    And I count the JobSteps and I find 2 JobStep within 30 seconds
    Then No exception was thrown
    And I start a job
    Given I query for the job with the name "TestJob" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for the last job target in the database
    And I confirm the step index is 0 and status is "PROCESS_FAILED"
    And I logout

  @teardown
  Scenario: Stop full docker environment
    Given Stop full docker environment
    And Clean Locator Instance
