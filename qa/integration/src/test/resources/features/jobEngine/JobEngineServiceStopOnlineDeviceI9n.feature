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
@jobEngineServiceStop
@env_docker

Feature: JobEngineService stop job tests with online device
  Job Engine Service test scenarios for stopping job. This feature file contains scenarios for stopping job with one target and one step,
  one target and multiple steps, multiple targets and one step and multiple targets and multiple steps.

  @setup
  Scenario: Start full docker environment
    Given Init Jaxb Context
    And Init Security Context
    And Start full docker environment

    # *****************************************************
    # * Stopping a job with one Target and multiple Steps *
    # *****************************************************

#  Scenario: Stop job with multiple Bundle Start and Package Install steps and one target
#  Create a new job and set a connected KuraMock device as the job target.
#  Add Bundle Start and Package Install steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 1 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 1, and the status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I start the Kura Mock
#    And Device is connected within 10 seconds
#    And Device status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock device after 5 seconds
#    And Bundles are requested
#    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
#    And Packages are requested and 1 package is received
#    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add target to job
#    And I search for the job targets in database
#    And I count 1
#    And I search for step definition with the name
#      | Bundle Start               |
#      | Package Download / Install |
#      | Package Uninstall          |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                    | type                                                                                               | value                                                                                                                                                                                                                                                            |
#      | bundleId                | java.lang.String                                                                                   | 34                                                                                                                                                                                                                                                               |
#      | packageDownloadRequest  | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest   | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
#      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                                           |
#      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                                            |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 3 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is different than 2 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 2 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    When Bundles are requested
#    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "ACTIVE"
#    And Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple Bundle Stop and Package Uninstall steps and one target
#  Create a new job and set a connected KuraMock device as the job target.
#  Add two Bundle Stop and Package Uninstall steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 2 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 2, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I start the Kura Mock
#    And Device is connected within 10 seconds
#    And Device status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock device after 5 seconds
#    And Bundles are requested
#    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
#    And Packages are requested and 1 package is received
#    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add target to job
#    And I search for the job targets in database
#    And I count 1
#    And I search for step definition with the name
#      | Bundle Stop                |
#      | Package Uninstall          |
#      | Package Download / Install |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                    | type                                                                                               | value                                                                                                                                                                                                                                                            |
#      | bundleId                | java.lang.String                                                                                   | 77                                                                                                                                                                                                                                                               |
#      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                                           |
#      | packageDownloadRequest  | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest   | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
#      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                                            |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 3 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is different than 2 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 2 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    When Bundles are requested
#    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "RESOLVED"
#    And Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple Command Execution and Package Install steps and one target
#  Create a new job and set a connected KuraMock device as the job target.
#  Add two Command Execution and Package Install steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 1 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 1, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I start the Kura Mock
#    And Device is connected within 10 seconds
#    And Device status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock device after 5 seconds
#    And Command "pwd" is executed
#    And Packages are requested and 1 package is received
#    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add target to job
#    And I search for the job targets in database
#    And I count 1
#    And I search for step definition with the name
#      | Command Execution          |
#      | Package Download / Install |
#      | Package Uninstall          |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                    | type                                                                                               | value                                                                                                                                                                                                                                                            |
#      | commandInput            | org.eclipse.kapua.service.device.management.command.DeviceCommandInput                             | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput>                                                                                                                    |
#      | packageDownloadRequest  | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest   | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
#      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                                           |
#      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                                            |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 3 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is different than 2 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 2 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    And Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple Configuration Put and Package Uninstall steps and one target
#  Create a new job and set a connected KuraMock device as the job target.
#  Add two Configuration Put and Package Uninstall steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 1 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 1, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I start the Kura Mock
#    And Device is connected within 10 seconds
#    And Device status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock device after 5 seconds
#    And Configuration is requested
#    Then A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "5"
#    And Packages are requested and 1 packages is received
#    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add target to job
#    And I search for the job targets in database
#    And I count 1
#    And I search for step definition with the name
#      | Configuration Put          |
#      | Package Uninstall          |
#      | Package Download / Install |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                    | type                                                                                               | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
#      | configuration           | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration                      | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.clock.ClockService></id><properties><property name="clock.ntp.host" array="false" encrypted="false" type="String"><value>0.pool.ntp.org</value></property><property name="clock.provider" array="false" encrypted="false" type="String"><value>java-ntp</value></property><property name="clock.ntp.port" array="false" encrypted="false" type="Integer"><value>123</value></property><property name="clock.ntp.max-retry" array="false" encrypted="false" type="Integer"><value>0</value></property><property name="clock.ntp.refresh-interval" array="false" encrypted="false" type="Integer"><value>3600</value></property><property name="clock.set.hwclock" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="enabled" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="clock.ntp.timeout" array="false" encrypted="false" type="Integer"><value>10000</value></property><property name="clock.ntp.retry.interval" array="false" encrypted="false" type="Integer"><value>10</value></property></properties></configuration></configurations> |
#      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
#      | packageDownloadRequest  | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest   | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
#      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 3 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is different than 2 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 2 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    Then Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple Asset Write and Package Install steps and one target
#  Create a new job and set a connected KuraMock device as the job target.
#  Add two Asset Write and Package Install steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 1 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 1, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I start the Kura Mock
#    And Device is connected within 10 seconds
#    And Device status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock device after 5 seconds
#    When Device assets are requested
#    Then Asset with name "asset1" and channel with name "channel1" and value 123 are received
#    And Packages are requested and 1 package is received
#    When I search for events from device "rpione3" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add target to job
#    And I search for the job targets in database
#    And I count 1
#    And I search for step definition with the name
#      | Asset Write                |
#      | Package Download / Install |
#      | Package Uninstall          |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                    | type                                                                                               | value                                                                                                                                                                                                                                                            |
#      | assets                  | org.eclipse.kapua.service.device.management.asset.DeviceAssets                                     | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>asset1</name><channels><channel><valueType>java.lang.Integer</valueType><value>1233</value><name>channel1</name></channel></channels></deviceAsset></deviceAssets>                        |
#      | packageDownloadRequest  | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest   | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
#      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                                           |
#      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                                            |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 3 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is different than 2 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 2 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    When Device assets are requested
#    Then Asset with name "asset1" and channel with name "channel1" and value 1233 are received
#    And Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#    # *****************************************************
#    # * Stopping a job with multiple Targets and one Step *
#    # *****************************************************
#
#  Scenario: Stop job with multiple targets and Bundle Start and Package Install steps
#  Create a new job and set a connected KuraMock devices as the job targets.
#  Add Bundle Start and Package Install steps to the created job. Start the job. Before
#  job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 0 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 0, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I add 2 devices to Kura Mock
#    And Devices are connected within 10 seconds
#    And I wait 1 second
#    And Devices status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock devices after 5 seconds
#    And Bundles are requested
#    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "RESOLVED"
#    And Packages are requested and 1 package is received
#    When I search for events from device "device0" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add targets to job
#    And I search for the job targets in database
#    And I count 2
#    And I search for step definition with the name
#      | Bundle Start               |
#      | Package Download / Install |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                   | type                                                                                             | value                                                                                                                                                                                                                                                            |
#      | bundleId               | java.lang.String                                                                                 | 34                                                                                                                                                                                                                                                               |
#      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
#    And I create multiple new JobSteps from the existing creators
#    And I count the JobSteps and I find 2 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is 0 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    When Bundles are requested
#    Then A bundle named "slf4j.api" with id 34 and version "1.7.21" is present and "ACTIVE"
#    And Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple targets and Bundle Stop and Package Uninstall steps
#  Create a new job and set a connected KuraMock devices as the job targets.
#  Add Bundle Stop and Package Uninstall steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 0 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 0, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I add 2 devices to Kura Mock
#    And Devices are connected within 10 seconds
#    And I wait 1 second
#    And Devices status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock devices after 5 seconds
#    And Bundles are requested
#    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "ACTIVE"
#    And Packages are requested and 1 package is received
#    When I search for events from device "device0" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add targets to job
#    And I search for the job targets in database
#    And I count 2
#    And I search for step definition with the name
#      | Bundle Stop       |
#      | Package Uninstall |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                    | type                                                                                               | value                                                                                                                                                                                                  |
#      | bundleId                | java.lang.String                                                                                   | 77                                                                                                                                                                                                     |
#      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest> |
#      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                  |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 2 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is 0 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    When Bundles are requested
#    And A bundle named "org.eclipse.kura.linux.bluetooth" with id 77 and version "1.0.300" is present and "RESOLVED"
#    And Packages are requested and 0 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple targets and Command Execution and Package Install steps
#  Create a new job and set a connected KuraMock devices as the job targets.
#  Add Command Execution and Package Install steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 0 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 0, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I add 2 devices to Kura Mock
#    And Devices are connected within 10 seconds
#    And I wait 1 second
#    And Devices status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock devices after 5 seconds
#    And Command "pwd" is executed
#    And Packages are requested and 1 package is received
#    When I search for events from device "device0" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add targets to job
#    And I search for the job targets in database
#    And I count 2
#    And I search for step definition with the name
#      | Command Execution          |
#      | Package Download / Install |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                   | type                                                                                             | value                                                                                                                                                                                                                                                            |
#      | commandInput           | org.eclipse.kapua.service.device.management.command.DeviceCommandInput                           | <?xml version="1.0" encoding="UTF-8"?><commandInput><command>pwd</command><timeout>30000</timeout><runAsynch>false</runAsynch></commandInput>                                                                                                                    |
#      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
#      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                                            |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 2 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is 0 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    When Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple targets and Configuration Put and Package Uninstall steps
#  Create a new job and set a connected KuraMock devices as the job targets.
#  Add Configuration Put and Package Uninstall steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 0 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 0, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I add 2 devices to Kura Mock
#    And Devices are connected within 10 seconds
#    And I wait 1 second
#    And Devices status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock devices after 5 seconds
#    And Configuration is requested
#    Then A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "5"
#    And Packages are requested and 1 packages is received
#    When I search for events from device "device0" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add targets to job
#    And I search for the job targets in database
#    And I count 2
#    And I search for step definition with the name
#      | Configuration Put |
#      | Package Uninstall |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                    | type                                                                                               | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
#      | configuration           | org.eclipse.kapua.service.device.management.configuration.DeviceConfiguration                      | <?xml version="1.0" encoding="UTF-8"?><configurations xmlns:ns0="http://www.osgi.org/xmlns/metatype/v1.2.0"><configuration><id>org.eclipse.kura.clock.ClockService></id><properties><property name="clock.ntp.host" array="false" encrypted="false" type="String"><value>0.pool.ntp.org</value></property><property name="clock.provider" array="false" encrypted="false" type="String"><value>java-ntp</value></property><property name="clock.ntp.port" array="false" encrypted="false" type="Integer"><value>123</value></property><property name="clock.ntp.max-retry" array="false" encrypted="false" type="Integer"><value>0</value></property><property name="clock.ntp.refresh-interval" array="false" encrypted="false" type="Integer"><value>3600</value></property><property name="clock.set.hwclock" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="enabled" array="false" encrypted="false" type="Boolean"><value>true</value></property><property name="clock.ntp.timeout" array="false" encrypted="false" type="Integer"><value>10000</value></property><property name="clock.ntp.retry.interval" array="false" encrypted="false" type="Integer"><value>10</value></property></properties></configuration></configurations> |
#      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>org.eclipse.kura.example.beacon</name><version>1.0.300</version><reboot>true</reboot><rebootDelay>10000</rebootDelay></uninstallRequest>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
#      | timeout                 | java.lang.Long                                                                                     | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 2 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is 0 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    And Configuration is requested
#    Then A Configuration named "org.eclipse.kura.clock.ClockService" has property "clock.ntp.retry.interval" with value "10"
#    And Packages are requested and 0 packages are received
#    Then KuraMock is disconnected
#    And I logout
#
#  Scenario: Stop job with multiple targets and Asset Write and Package Install steps and one target
#  Create a new job and set a connected KuraMock device as the job target.
#  Add two Asset Write and Package Install steps to the created job. Start the job.
#  Before job is finished, stop the job. When job is stopped, the executed target's
#  step index should be different than 1 and the status PROCESS_AWAITING. Start the job again.
#  If job is finished step index should be 1, and job target status PROCESS_OK.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And I add 2 devices to Kura Mock
#    And Devices are connected within 10 seconds
#    And I wait 1 second
#    And Devices status is "CONNECTED" within 10 seconds
#    And I select account "kapua-sys"
#    And I get the KuraMock devices after 5 seconds
#    When Device assets are requested
#    Then Asset with name "asset1" and channel with name "channel1" and value 123 are received
#    And Packages are requested and 1 package is received
#    When I search for events from device "device0" in account "kapua-sys" I find 3 events within 30 seconds
#    And The type of the last event is "DEPLOY"
#    And I create a job with the name "TestJob"
#    And I add targets to job
#    And I search for the job targets in database
#    And I count 2
#    And I search for step definition with the name
#      | Asset Write                |
#      | Package Download / Install |
#    And I prepare a JobStepCreator with the name "TestStep1" and properties
#      | name                   | type                                                                                             | value                                                                                                                                                                                                                                                            |
#      | assets                 | org.eclipse.kapua.service.device.management.asset.DeviceAssets                                   | <?xml version="1.0" encoding="UTF-8"?><deviceAssets><deviceAsset><name>asset1</name><channels><channel><valueType>java.lang.Integer</valueType><value>1233</value><name>channel1</name></channel></channels></deviceAsset></deviceAssets>                        |
#      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.example.publisher_1.0.300.dp</uri><name>Example Publisher</name><version>1.0.300</version><install>true</install></downloadRequest> |
#      | timeout                | java.lang.Long                                                                                   | 10000                                                                                                                                                                                                                                                            |
#    And I create multiple new JobSteps from the existing creators
#    Then No exception was thrown
#    And I count the JobSteps and I find 2 JobStep within 30 seconds
#    And I start a job
#    And I wait for 10 milliseconds for processes to settle down
#    And I stop the job
#    And I search for the last job target in the database
#    And I confirm the step index is different than 1 and status is "PROCESS_AWAITING"
#    And I start a job
#    And I confirm job target has step index 1 and status "PROCESS_OK" within 31 seconds
#    When I query for the execution items for the current job and I count 2 or more finished within 30 seconds
#    When Device assets are requested
#    Then Asset with name "asset1" and channel with name "channel1" and value 1233 are received
#    And Packages are requested and 2 packages are received
#    Then KuraMock is disconnected
#    And I logout

  @teardown
  Scenario: Stop full docker environment
    Given Stop full docker environment
    And Clean Locator Instance
