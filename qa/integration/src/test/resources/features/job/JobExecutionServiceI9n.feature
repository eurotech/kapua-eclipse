###############################################################################
# Copyright (c) 2017, 2024 Eurotech and/or its affiliates and others
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
@env_docker_base
@it # This is an IT because Job.*Service operations may require a Job Engine instance running
@job
@jobExecutionService

Feature: Job Execution service CRUD tests
  The Job service is responsible for maintaining the status of the target step executions.

  @setup
  Scenario: Setup test resources
    Given Init Security Context
    And Start Docker environment with resources
      | db            |
      | events-broker |
      | job-engine    |

  Scenario: Regular job execution creation

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob"
    And A regular job execution item
    Then No exception was thrown
    And The job execution matches the creator

  Scenario: Update job id of an existing execution item

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob"
    And A regular job execution item
    Then I create a job with the name "TestJob2"
    When I update the job id for the execution item
    Then No exception was thrown

  Scenario: Update the end time of an existing execution item

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob"
    And A regular job execution item
    When I update the end time of the execution item as if the job finished now
    Then No exception was thrown
    When I search for the last job execution in the database
    Then The job execution items match

  Scenario: Delete a job execution item

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob"
    And A regular job execution item
    Then I delete the last job execution in the database
    When I search for the last job execution in the database
    Then There is no such job execution item in the database

  Scenario: Delete a job execution item twice

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob"
    And A regular job execution item
    Then I delete the last job execution in the database
    Given I expect the exception "KapuaEntityNotFoundException" with the text "jobExecution"
    Then I delete the last job execution in the database
    Then An exception was thrown

  Scenario: Create and count several execution items for a job

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob"
    And A regular job execution item
    And A regular job execution item
    And A regular job execution item
    And A regular job execution item
    Then No exception was thrown
    When I count the execution items for the current job
    Then I count 4

  Scenario: Query for executions of a specific job

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob1"
    And A regular job execution item
    And A regular job execution item
    And A regular job execution item
    And A regular job execution item
    Given I create a job with the name "TestJob2"
    And A regular job execution item
    And A regular job execution item
    And A regular job execution item
    Given I create a job with the name "TestJob3"
    And A regular job execution item
    And A regular job execution item
    Given I query for the job with the name "TestJob2"
    When I query for the execution items for the current job
    Then I count 3


  Scenario: Query for executions of a specific job using start date

    Given I login as user with name "kapua-sys" and password "kapua-password"
    * I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    * I create a job with the name "TestJob"
    * A regular job execution item
    * A regular job execution item
    * A regular job execution item
    * A regular job execution item

    When I query for the execution items for the current job starting from date in the future
    Then I count 0

    When I query for the execution items for the current job starting from date in the past
    Then I count 4

  Scenario: Job execution factory sanity checks

    And I test the sanity of the job execution factory

  Scenario: Update the end time of an existing execution item and see if status is computed correctly

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the job service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I create a job with the name "TestJob"
    And A regular job execution item
    When I update the end time of the execution item as if the job finished now
    Then No exception was thrown
    When I search for the last job execution in the database
    Then The job execution status is "TERMINATED"
    When I update the end time of the execution item as if the job never finished
    Then No exception was thrown
    When I search for the last job execution in the database
    Then The job execution status is "RUNNING"

  @teardown
  Scenario: Tear down test resources
    Given Stop Docker environment
    And Clean Locator Instance
    And Reset Security Context
