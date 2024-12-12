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
#     Eurotech - initial API and implementation
###############################################################################
@device
@env_none

Feature: Account Device Registry Service Integration Tests

  @setup
  Scenario: Initialize test environment
    Given Init Security Context

  Scenario: Creating Devices Under Account That Allows Infinite Child Devices
  Login as kapua-sys, create an account
  Configure DeviceRegistryService of that account, set infiniteChildDevices to true and maxNumberChildDevices to 0
  Create a few Devices
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create a device with name "Device1"
    And I create a device with name "Device2"
    And I create a device with name "Device3"
    Then No exception was thrown
    And I logout

  Scenario: Creating Devices Under Account That Has Limited Child Devices
  Login as kapua-sys, create an account
  Configure DeviceRegistryService of that account, set infiniteChildDevices to false and maxNumberChildDevices to 3
  Create a few Devices
  Only 3 Devices should be created, creating more will throw an Exception

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 3     |
    Given I select account "acc1"
    When I create a device with name "Device1"
    And I create a device with name "Device2"
    And I create a device with name "Device3"
    Then No exception was thrown
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I expect the response status code 403
    When I create a device with name "Device4"
    Then An exception was thrown
    And Response status code match
    And I logout

  Scenario: Creating Devices Under Account That Does Not Allow Devices
  Login as kapua-sys, create an account
  Configure DeviceRegistryService of that account, set infiniteChildDevices to false and maxNumberChildDevices to 0
  Try to create a device
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    When I create a device with name "Device1"
    Then An exception was thrown
    And I logout

  Scenario: Creating Devices And Than Setting Device Service So It Does Not Allow Devices
  Login as kapua-sys, create an account
  Configure DeviceRegistryService of that account, set infiniteChildDevices to true
  Create a few Devices
  Configure DeviceRegistryService of that account, set infiniteChildDevices to false
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create a device with name "Device1"
    When I create a device with name "Device2"
    When I create a device with name "Device3"
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "*"
    Then I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Creating Devices And Then Changing Device Service Values
  Login as kapua-sys, create an account
  Configure DeviceRegistryService of that account, set infiniteChildDevices to true
  Create 2 Devices
  Configure DeviceRegistryService of that account, set infiniteChildDevices to false and maxNumberChildDevices to 2
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create a device with name "Device1"
    When I create a device with name "Device2"
    Then I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then No exception was thrown
    And I logout

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
