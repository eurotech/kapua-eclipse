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
@job
@jobStepService
@env_none

Feature: JobStepService CRUD tests

  @setup
  @KapuaProperties("locator.class.impl=org.eclipse.kapua.qa.common.MockedLocator")
  Scenario: Initialize test environment
    Given Init Security Context

  Scenario: JobStepService.create

    Given I create a job with the name "TestJob"
    And I create a JobStepDefinition with the name "TestDefinition" and the following properties
      | name  | type             |
      | prop1 | java.lang.String |
      | prop2 | java.lang.String |
      | prop3 | java.lang.String |
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
      | prop2 | java.lang.String | v2    |
      | prop3 | java.lang.String | v3    |
    When I create a new JobStep from the existing creator
    Then I look for the last JobStep
    And The JobStep matches the creator

  Scenario: JobStepService.create scopeId null

    Given I create a job with the name "TestJob"
    And A null scope
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
      | prop2 | java.lang.String | v2    |
      | prop3 | java.lang.String | v3    |
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "scopeId"
    When I create a new JobStep from the existing creator
    Then An exception was thrown

  Scenario: JobStepService.update name

    Given I create a job with the name "TestJob"
    And I create a JobStepDefinition with the name "TestDefinition" and the following properties
      | name  | type             |
      | prop1 | java.lang.String |
      | prop2 | java.lang.String |
      | prop3 | java.lang.String |
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
    And I create a new JobStep from the existing creator
    When I update the JobStep.name to "TestStep2"
    And I query for a JobStep with the name "TestStep2"
    Then I count 1

  Scenario: JobStepService.update stepIndex forward

    Given I create a job with the name "TestJob"
    And I create a JobStepDefinition with the name "TestDefinition" and the following properties
      | name  | type             |
      | prop1 | java.lang.String |
      | prop2 | java.lang.String |
      | prop3 | java.lang.String |
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
    And I create a new JobStep from the existing creator
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name  | type             | value |
      | prop2 | java.lang.String | v2    |
    And I create a new JobStep from the existing creator
    And I prepare a JobStepCreator with the name "TestStep3" and the following properties
      | name  | type             | value |
      | prop3 | java.lang.String | v3    |
    And I create a new JobStep from the existing creator
    When I look for the JobStep with name "TestStep1"
    And I update the JobStep.stepIndex to 2
    And I look for the JobStep with name "TestStep2"
    Then The JobStep.stepIndex is 0
    And I look for the JobStep with name "TestStep3"
    Then The JobStep.stepIndex is 1
    And I look for the JobStep with name "TestStep1"
    Then The JobStep.stepIndex is 2

  Scenario: JobStepService.update stepIndex backward

    Given I create a job with the name "TestJob"
    And I create a JobStepDefinition with the name "TestDefinition" and the following properties
      | name  | type             |
      | prop1 | java.lang.String |
      | prop2 | java.lang.String |
      | prop3 | java.lang.String |
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
    And I create a new JobStep from the existing creator
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name  | type             | value |
      | prop2 | java.lang.String | v2    |
    And I create a new JobStep from the existing creator
    And I prepare a JobStepCreator with the name "TestStep3" and the following properties
      | name  | type             | value |
      | prop3 | java.lang.String | v3    |
    And I create a new JobStep from the existing creator
    When I look for the JobStep with name "TestStep3"
    And I update the JobStep.stepIndex to 0
    And I look for the JobStep with name "TestStep3"
    Then The JobStep.stepIndex is 0
    And I look for the JobStep with name "TestStep1"
    Then The JobStep.stepIndex is 1
    And I look for the JobStep with name "TestStep2"
    Then The JobStep.stepIndex is 2

  Scenario: JobStepService.count

    Given I create a job with the name "TestJob"
    And I create a JobStepDefinition with the name "TestDefinition" and the following properties
      | name  | type             |
      | prop1 | java.lang.String |
      | prop2 | java.lang.String |
      | prop3 | java.lang.String |
    And I prepare a JobStepCreator with the name "TestStep1" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
    And I create a new JobStep from the existing creator
    And I prepare a JobStepCreator with the name "TestStep2" and the following properties
      | name  | type             | value |
      | prop2 | java.lang.String | v2    |
    And I create a new JobStep from the existing creator
    And I prepare a JobStepCreator with the name "TestStep3" and the following properties
      | name  | type             | value |
      | prop3 | java.lang.String | v3    |
    And I create a new JobStep from the existing creator
    When I count the JobSteps in the current scope
    Then I count 3

  Scenario: JobStepService.delete

    Given I create a job with the name "TestJob"
    And I create a JobStepDefinition with the name "TestDefinition" and the following properties
      | name  | type             |
      | prop1 | java.lang.String |
      | prop2 | java.lang.String |
      | prop3 | java.lang.String |
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
    And I create a new JobStep from the existing creator
    When I delete the last JobStep
    And I look for the last JobStep
    Then The JobStep is not found

  Scenario: JobStepService.delete non-existing
    Given I create a job with the name "TestJob"
    And I create a JobStepDefinition with the name "TestDefinition" and the following properties
      | name  | type             |
      | prop1 | java.lang.String |
      | prop2 | java.lang.String |
      | prop3 | java.lang.String |
    And I prepare a JobStepCreator with the name "TestStep" and the following properties
      | name  | type             | value |
      | prop1 | java.lang.String | v1    |
    And I create a new JobStep from the existing creator
    And I delete the last JobStep
    Given I expect the exception "KapuaEntityNotFoundException" with the text "jobStep"
    When I delete the last JobStep
    Then An exception was thrown

  Scenario: Step factory sanity checks
    Given I test the JobStepFactory

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
