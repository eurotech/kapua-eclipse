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
@tag
@env_none

Feature: Account Tag Service Integration Tests

  @setup
  Scenario: Initialize test environment
    Given Init Jaxb Context
    And Init Security Context

  Scenario: Creating Tags Under Account That Allows Infinite Child Devices
  Login as kapua-sys, create an account
  Configure TagService of that account, set infiniteChildTags to true and maxNumberChildTags to 0
  Create a few Tags
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create tag with name "tag1" without description
    And I create tag with name "tag2" without description
    And I create tag with name "tag3" without description
    Then No exception was thrown
    And I logout

  Scenario: Creating Tags Under Account That Has Limited Child Tags
  Login as kapua-sys, create an account
  Configure TagService of that account, set infiniteChildTags to false and maxNumberChildTags to 3
  Create a few Tags
  Only 3 Tags should be created, creating more will throw an Exception

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 3     |
    Given I select account "acc1"
    When I create tag with name "tag1" without description
    And I create tag with name "tag2" without description
    And I create tag with name "tag3" without description
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I expect the response status code 403
    When I create tag with name "tag4" without description
    Then An exception was thrown
    And Response status code match
    And I logout

  Scenario: Creating Tags Under Account That Does Not Allow Tags
  Login as kapua-sys, create an account
  Configure TagService of that account, set infiniteChildTags to false and maxNumberChildTags to 0
  Try to create a group
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    When I create tag with name "tag1" without description
    Then An exception was thrown
    And I logout

  Scenario: Creating Tags And Than Setting Tag Service So It Does Not Allow Tags
  Login as kapua-sys, create an account
  Configure TagService of that account, set infiniteChildTags to true
  Create a few Tags
  Configure TagService of that account, set infiniteChildTags to false
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create tag with name "tag1" without description
    When I create tag with name "tag2" without description
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "The maximum of resources for the org.eclipse.kapua.service.tag.TagService service for the account"
    When I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Creating Tags And Then Changing Tag Service Values
  Login as kapua-sys, create an account
  Configure TagService of that account, set infiniteChildTags to true
  Create 2 Tags
  Configure TagService of that account, set infiniteChildTags to false and maxNumberChildTags to 2
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create tag with name "tag1" without description
    When I create tag with name "tag2" without description
    When I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then No exception was thrown
    And I logout

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
