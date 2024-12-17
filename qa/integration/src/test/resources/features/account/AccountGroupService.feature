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
@group
@env_none

Feature: Account Group Service Integration Tests

  @setup
  Scenario: Initialize test environment
    Given Init Security Context

  Scenario: Creating Groups Under Account That Allows Infinite Child Groups
  Login as kapua-sys, create an account
  Configure GroupService of that account, set infiniteChildGroups to true and maxNumberChildGroups to 0
  Create a few groups
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the group service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    And I create a group with name "Group1"
    And I create a group with name "Group2"
    Then No exception was thrown
    And I logout

  Scenario: Creating Groups Under Account That Has Limited Child Groups
  Login as kapua-sys, create an account
  Configure GroupService of that account, set infiniteChildGroups to false and maxNumberChildGroups to 3
  Create a few groups
  Only 3 Groups should be created, creating more will throw an Exception

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the group service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 3     |
    Then I select account "acc1"
    And I create a group with name "Group1"
    And I create a group with name "Group2"
    And I create a group with name "Group3"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I expect the response status code 403
    And I create a group with name "Group4"
    Then An exception was thrown
    And Response status code match
    And I logout

  Scenario: Creating Groups Under Account That Does Not Allow Groups
  Login as kapua-sys, create an account
  Configure GroupService of that account, set infiniteChildGroups to false and maxNumberChildGroups to 0
  Try to create a group
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the group service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I create a group with name "Group1"
    Then An exception was thrown
    And I logout

  Scenario: Creating Groups And Than Setting Group Service So It Does Not Allow Groups
  Login as kapua-sys, create an account
  Configure GroupService of that account, set infiniteChildGroups to true
  Create a few Groups
  Configure GroupService of that account, set infiniteChildGroups to false
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the group service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    And I create a group with name "Group1"
    And I create a group with name "Group2"
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "*"
    And I configure the group service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Creating Groups And Then Changing InfiniteChildGroups To False And Set MaxNumberChildGroups
  Login as kapua-sys, create an account
  Configure GroupService of that account, set infiniteChildGroups to true
  Create 2 Groups
  Configure GroupService of that account, set infiniteChildGroups to false and maxNumberChildGroups to 2
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the group service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    And I create a group with name "Group1"
    And I create a group with name "Group2"
    And I configure the group service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then No exception was thrown
    And I logout

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
