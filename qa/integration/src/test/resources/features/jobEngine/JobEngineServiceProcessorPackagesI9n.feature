###############################################################################
# Copyright (c) 2024, 2024 Eurotech and/or its affiliates and others
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
@jobEngineTargetProcessors

Feature: Job Engine Service - Packages Step Processors
  Tests for Device Management Packages Processor

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

  Scenario: Package Install - XML

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device birth message is sent
    And Device "rpione3" is connected within 10s
    And I create a job with the name "TestJob"
    And I add device targets to job
      | rpione3 |
    And I search for step definition with the name
      | Package Download / Install |
    And I add job step to job with name "Test Step - Package Download and Install - XML" and with selected job step definition and properties
      | name                   | type                                                                                             | value                                                                                                                                                                                                                                           |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | <?xml version="1.0" encoding="UTF-8"?><downloadRequest><uri>http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.demo.heater_1.0.300.dp</uri><name>heater</name><version>1.0.300</version><install>true</install></downloadRequest> |
      | timeout                | java.lang.Long                                                                                   | 5000                                                                                                                                                                                                                                           |
    When I start a job
    And I wait job to finish its execution up to 5s
    Then I confirm that job has 1 job execution
    And I confirm that job target in job has step index 0 and status "AWAITING_COMPLETION"
    Then I wait job target to finish processing and notify completion up to 10s
    And I wait for another job start up to 10s
    And I wait job to finish its execution up to 5s
    And I confirm that job has 2 job execution
    And I confirm that job target in job has step index 0 and status "PROCESS_OK"

  Scenario: Package Install - JSON

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device birth message is sent
    And Device "rpione3" is connected within 10s
    And I create a job with the name "TestJob"
    And I add device targets to job
      | rpione3 |
    And I search for step definition with the name
      | Package Download / Install |
    And I add job step to job with name "Test Step - Package Download and Install - JSON" and with selected job step definition and properties
      | name                   | type                                                                                             | value                                                                                                                                                         |
      | packageDownloadRequest | org.eclipse.kapua.service.device.management.packages.model.download.DevicePackageDownloadRequest | { "uri": "http://download.eclipse.org/kura/releases/3.2.0/org.eclipse.kura.demo.heater_1.0.300.dp", "name": "heater", "version": "1.0.300", "install": true } |
      | timeout                | java.lang.Long                                                                                   | 5000                                                                                                                                                          |
    When I start a job
    And I wait job to finish its execution up to 5s
    Then I confirm that job has 1 job execution
    And I confirm that job target in job has step index 0 and status "AWAITING_COMPLETION"
    Then I wait job target to finish processing and notify completion up to 10s
    And I wait for another job start up to 10s
    And I wait job to finish its execution up to 5s
    And I confirm that job has 2 job execution
    And I confirm that job target in job has step index 0 and status "PROCESS_OK"

  Scenario: Package Uninstall - XML

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device birth message is sent
    And Device "rpione3" is connected within 10s
    And I create a job with the name "TestJob"
    And I add device targets to job
      | rpione3 |
    And I search for step definition with the name
      | Package Uninstall |
    And I add job step to job with name "Test Step - Package Uninstall - XML" and with selected job step definition and properties
      | name                    | type                                                                                               | value                                                                                                                                                                          |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | <?xml version="1.0" encoding="UTF-8"?><uninstallRequest><name>heater</name><version>1.0.300</version><reboot>false</reboot><rebootDelay>30000</rebootDelay></uninstallRequest> |
      | timeout                 | java.lang.Long                                                                                     | 5000                                                                                                                                                                           |
    When I start a job
    And I wait job to finish its execution up to 5s
    Then I confirm that job has 1 job execution
    And I confirm that job target in job has step index 0 and status "AWAITING_COMPLETION"
    Then I wait job target to finish processing and notify completion up to 10s
    And I wait for another job start up to 10s
    And I wait job to finish its execution up to 5s
    And I confirm that job has 2 job execution
    And I confirm that job target in job has step index 0 and status "PROCESS_OK"

  Scenario: Package Uninstall - JSON

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device birth message is sent
    And Device "rpione3" is connected within 10s
    And I create a job with the name "TestJob"
    And I add device targets to job
      | rpione3 |
    And I search for step definition with the name
      | Package Uninstall |
    And I add job step to job with name "Test Step - Package Uninstall - JSON" and with selected job step definition and properties
      | name                    | type                                                                                               | value                                                                                                   |
      | packageUninstallRequest | org.eclipse.kapua.service.device.management.packages.model.uninstall.DevicePackageUninstallRequest | { "name": "org.eclipse.kura.demo.heater", "version": "1.0.500", "reboot": false, "rebootDelay": 30000 } |
      | timeout                 | java.lang.Long                                                                                     | 5000                                                                                                    |
    When I start a job
    And I wait job to finish its execution up to 5s
    Then I confirm that job has 1 job execution
    And I confirm that job target in job has step index 0 and status "AWAITING_COMPLETION"
    Then I wait job target to finish processing and notify completion up to 10s
    And I wait for another job start up to 10s
    And I wait job to finish its execution up to 5s
    And I confirm that job has 2 job execution
    And I confirm that job target in job has step index 0 and status "PROCESS_OK"

  @teardown
  Scenario: Tear down test resources
    Given I logout
    And KuraMock is disconnected
    And Stop Docker environment
    And Clean Locator Instance