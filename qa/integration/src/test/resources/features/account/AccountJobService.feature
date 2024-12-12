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
@account
@job
@env_none

Feature: Account Job Service Integration Tests

  @setup
  Scenario: Initialize test environment
    Given Init Jaxb Context
    And Init Security Context

  Scenario: Creating Jobs Under Account That Allows Infinite Child Devices
  Login as kapua-sys, create an account
  Configure JobRegistryService of that account, set infiniteChildJobs to true and maxNumberChildJobs to 0
  Create a few Jobs
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create a job with the name "job1"
    And I create a job with the name "job2"
    And I create a job with the name "job3"
    Then No exception was thrown
    And I logout

  Scenario: Creating Jobs Under Account That Has Limited Child Jobs
  Login as kapua-sys, create an account
  Configure JobRegistryService of that account, set infiniteChildJobs to false and maxNumberChildJobs to 3
  Create a few Jobs
  Only 3 Jobs should be created, creating more will throw an Exception

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 3     |
    Given I select account "acc1"
    When I create a job with the name "job1"
    And I create a job with the name "job2"
    And I create a job with the name "job3"
    Then No exception was thrown
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I expect the response status code 403
    When I create a job with the name "job4"
    Then An exception was thrown
    And Response status code match
    And I logout

  Scenario: Creating Jobs Under Account That Does Not Allow Jobs
  Login as kapua-sys, create an account
  Configure JobRegistryService of that account, set infiniteChildJobs to false and maxNumberChildJobs to 0
  Try to create a job
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    When I create a job with the name "job1"
    Then An exception was thrown
    And I logout

  Scenario: Creating Jobs And Than Setting Job Service So It Does Not Allow Jobs
  Login as kapua-sys, create an account
  Configure JobRegistryService of that account, set infiniteChildJobs to true
  Create a few Jobs
  Configure JobRegistryService of that account, set infiniteChildJobs to false
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create a job with the name "job1"
    When I create a job with the name "job2"
    When I create a job with the name "job3"
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "*"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Creating Jobs And Then Changing Job Service Values
  Login as kapua-sys, create an account
  Configure JobRegistryService of that account, set infiniteChildJobs to true
  Create 2 Jobs
  Configure JobRegistryService of that account, set infiniteChildJobs to false and maxNumberChildJobs to 2
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Given I select account "acc1"
    When I create a job with the name "job1"
    When I create a job with the name "job2"
    When I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then No exception was thrown
    And I logout

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
