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
@user
@env_none

Feature: Account User Service Integration Tests

  @setup
  Scenario: Initialize test environment
    Given Init Jaxb Context
    And Init Security Context

  Scenario: Creating Users Under Account That Allows Infinite Child Users
  Login as kapua-sys, create an account
  Configure UserService of that account, set infiniteChildUsers to true and maxNumberChildUsers to 0
  Create a few Users
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create user with name "user1"
    And I create user with name "user2"
    And I create user with name "user3"
    Then No exception was thrown
    And I logout

  Scenario: Creating Users Under Account That Has Limited Child Users
  Login as kapua-sys, create an account
  Configure UserService of that account, set infiniteChildUsers to false and maxNumberChildUsers to 3
  Create a few Users
  Only 3 Users should be created, creating more will throw an Exception

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 3     |
    Given I select account "acc1"
    When I create user with name "user1"
    And I create user with name "user2"
    And I create user with name "user3"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I expect the response status code 403
    When I create user with name "user4"
    Then An exception was thrown
    And Response status code match
    And I logout

  Scenario: Creating Users Under Account That Does Not Allow Users
  Login as kapua-sys, create an account
  Configure UserService of that account, set infiniteChildUsers to false and maxNumberChildUsers to 0
  Try to create a user
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    When I create user with name "user0"
    Then An exception was thrown
    And I logout

  Scenario: Creating Users And Than Setting User Service So It Does Not Allow Users
  Login as kapua-sys, create an account
  Configure UserService of that account, set infiniteChildUsers to true
  Create a few Users
  Configure UserService of that account, set infiniteChildUsers to false
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create user with name "user0"
    And I create user with name "user1"
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "The maximum of resources for the org.eclipse.kapua.service.user.UserService service for the account"
    When I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Creating Users And Then Changing User Service Values
  Login as kapua-sys, create an account
  Configure UserService of that account, set infiniteChildUsers to true
  Create 2 Users
  Configure UserService of that account, set infiniteChildUsers to false and maxNumberChildUsers to 2
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create user with name "user0"
    And I create user with name "user1"
    When I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then No exception was thrown
    And I logout

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
