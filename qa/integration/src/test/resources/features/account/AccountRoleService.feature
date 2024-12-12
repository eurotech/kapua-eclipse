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
@role
@env_none

Feature: Account Role Service Integration Tests

  @setup
  Scenario: Initialize test environment
    Given Init Jaxb Context
    And Init Security Context

  Scenario: Creating Roles Under Account That Allows Infinite Child Roles
  Login as kapua-sys, create an account
  Configure RoleRegistryService of that account, set infiniteChildRoles to true and maxNumberChildRoles to 0
  Create a few Roles
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create role "role1" in account "acc1"
    And I create role "role2" in account "acc1"
    And I create role "role3" in account "acc1"
    Then No exception was thrown
    And I logout

  Scenario: Creating Roles Under Account That Has Limited Child Roles
  Login as kapua-sys, create an account
  Configure RoleRegistryService of that account, set infiniteChildRoles to false and maxNumberChildRoles to 3
  Create a few Roles
  Only 3 Roles should be created, creating more will throw an Exception

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 3     |
    Given I select account "acc1"
    When I create role "role1" in account "acc1"
    And I create role "role2" in account "acc1"
    And I create role "role3" in account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I expect the response status code 403
    When I create role "role4" in account "acc1"
    Then An exception was thrown
    And Response status code match
    And I logout

  Scenario: Creating Roles Under Account That Does Not Allow Roles
  Login as kapua-sys, create an account
  Configure RoleRegistryService of that account, set infiniteChildRoles to false and maxNumberChildRoles to 0
  Try to create a group
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    When I create role "role4" in account "acc1"
    Then An exception was thrown
    And I logout

  Scenario: Creating Roles And Than Setting Role Service So It Does Not Allow Roles
  Login as kapua-sys, create an account
  Configure RoleRegistryService of that account, set infiniteChildRoles to true
  Create a few Roles
  Configure RoleRegistryService of that account, set infiniteChildRoles to false
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create role "role1" in account "acc1"
    When I create role "role2" in account "acc1"
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "*"
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Creating Roles And Then Changing Role Service Values
  Login as kapua-sys, create an account
  Configure RoleRegistryService of that account, set infiniteChildRoles to true
  Create 2 Roles
  Configure RoleRegistryService of that account, set infiniteChildRoles to false and maxNumberChildRoles to 2
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create role "role1" in account "acc1"
    When I create role "role2" in account "acc1"
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then No exception was thrown
    And I logout

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
