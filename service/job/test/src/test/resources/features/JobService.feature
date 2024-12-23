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
@jobService
@env_none

Feature: Job service CRUD tests
  The Job service is responsible for maintaining jobs.

  @setup
  @KapuaProperties("locator.class.impl=org.eclipse.kapua.qa.common.MockedLocator")
  Scenario: Initialize test environment
    Given Init Security Context

  Scenario: Create a valid job entry
  Creating a role entry with specified name only. Once created, search for it - it should have been created.
  Kapua should not return any error.

    Given I prepare a job with name "jobN" and description "jobDescription"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "jobN"
    And No exception was thrown

  Scenario: Creating a job with null name
  Create a job entry, with null name and description e.g "jobDescription".
  Kapua should return an error.

    Given I prepare a job with name "" and description "jobDescription"
    And I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided for the argument jobCreator.name"
    When I create a new job entity from the existing creator
    Then An exception was thrown

  Scenario: Creating a job with name only
  Create a job with name "jobName" only.
  Kapua should not return any errors since description field is not mandatory.

    Given I prepare a job with name "jobN" and description ""
    And I create a new job entity from the existing creator
    When I search for the job in the database
    Then I find a job with name "jobN"
    And No exception was thrown

  Scenario: Creating job with too short name without description
  Create a job with too short name (e.g "jo").
  Kapua should return an error.

    Given I prepare a job with name "jo" and description ""
    And I expect the exception "KapuaIllegalArgumentException" with the text "Value less than allowed min length. Min length is: 3."
    When I create a new job entity from the existing creator
    Then An exception was thrown

  Scenario: Creating job with short name without description
  Create a job with short name (e.g "job").
  Kapua should not return an error.

    Given I prepare a job with name "job" and description ""
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "job"
    And No exception was thrown

  Scenario: Creating job with long name without description
  Create a job with 255 characters long name and without description.
  Kapua should not return any errors.

    Given I prepare a job with name "jobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjob" and description ""
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "jobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjob"
    And No exception was thrown

  Scenario: Creating job with too long name without description
  Create a job with 256 characters long name and without description.
  Kapua should return an error.

    Given I prepare a job with name "JjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjob" and description ""
    And I expect the exception "KapuaIllegalArgumentException" with the text "Value over than allowed max length. Max length is: 255."
    When I create a new job entity from the existing creator
    And An exception was thrown

  Scenario: Creating job with permitted symbols in name without description
  Create a job with permitted symbols in name (e.g "jobName_ or "jobName-").
  Kapua should not return any error.

    When I try to create job with permitted symbols "-_" in name
    And No exception was thrown

  Scenario: Creating job with invalid symbols in name without description
  Create a job with invalid symbols in name (e.g "jobName*" or "jobName/").
  Kapua should return an error.

    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument jobCreator.name"
    When I try to create job with invalid symbols "!#$%&'()=»Ç>:;<.,⁄@‹›€*ı–°·‚±Œ„‰?“‘”’ÉØ∏{}|ÆæÒÔÓÌÏÎÍÅ«" in name
    And An exception was thrown

  Scenario: Creating job without name and without description
  Create a job without name and without description.
  Kapua should return an error.

    Given I prepare a job with name "" and description ""
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided for the argument jobCreator.name"
    When I create a new job entity from the existing creator
    And An exception was thrown

  Scenario: Creating job with numbers in name without description
  Create a job that contains numbers in the name (e.g "jobName123").
  Kapua should not return any errors.

    Given I prepare a job with name "jobName123" and description ""
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "jobName123"
    And No exception was thrown

  Scenario: Creating unique job with non-unique description
  Create a job with unique name and with non-unique description (e.g "description").
  Kapua should not return any errors, description can be non-unique.

    Given I prepare a job with name "jobN" and description "description"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    When I find a job with name "jobN"
    Given I prepare a job with name "jobN1" and description "description"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "jobN1"
    And No exception was thrown

  Scenario: Creating non-unique job name with valid job description
  Create a non-unique job name (e.g "jobN") with valid description.
  Kapua should return an error. Job name must be unique.

    Given I prepare a job with name "jobN" and description "description"
    When I create a new job entity from the existing creator
    Then I prepare a job with name "jobN" and description "description123"
    And I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name jobN already exists."
    When I create a new job entity from the existing creator
    Then An exception was thrown

  Scenario: Creating job with short name and valid job description
  Create a job with short name (e.g "job") and valid description (e.g "description").
  Kapua should not return any error.

    Given I prepare a job with name "job" and description "description"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "job"
    And No exception was thrown

  Scenario: Creating job with too short name and valid description
  Create a job with too short name (e.g "j") and valid description (e.g "description").
  Kapua should return an error.

    Given I prepare a job with name "j" and description "description"
    And I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument jobCreator.name: Value less than allowed min length. Min length is: 3."
    When I create a new job entity from the existing creator
    Then An exception was thrown

  Scenario: Creating job with long name and valid description
  Create a job with 255 characters long name and description.
  Kapua should not return any errors.

    Given I prepare a job with name "jobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjob" and description "description"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "jobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjob"
    And No exception was thrown

  Scenario: Creating job with too long name and valid description
  Create a job with 256 characters long name and description.
  Kapua should not return any errors.

    Given I prepare a job with name "JjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjobNjob" and description "description"
    Given I expect the exception "KapuaIllegalArgumentException" with the text " An illegal value was provided for the argument jobCreator.name: Value over than allowed max length. Max length is: 255."
    When I create a new job entity from the existing creator
    And An exception was thrown

  Scenario: Creating a job without name with valid description
  Create a job without name but with description.
  Kapua should return an error. Name is mandatory.

    Given I prepare a job with name "" and description "description"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided for the argument jobCreator.name"
    When I create a new job entity from the existing creator
    And An exception was thrown

  Scenario: Creating job with numbers in name and valid description
  Create a job with name that contains numbers (e.g "jobName123") and with description (e.g "description").
  Kapua should not return any errors.

    Given I prepare a job with name "jobName123" and description "description"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with name "jobName123"
    And No exception was thrown

  Scenario: Creating unique job with short description
  Create a job with very short description (e.g "d").
  Kapua should not return any errors. Description field is not limited in any way.

    Given I prepare a job with name "jobN" and description "d"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with description "d"
    And No exception was thrown

  Scenario: Creating unique job with long description
  Create a unique job with description that has 255 characters.
  Kapua should not return any errors as Desription field can have max 255 characters.

    Given I prepare a job with name "jobN" and description "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondedescription"
    When I create a new job entity from the existing creator
    And I search for the job in the database
    Then I find a job with description "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondedescription"
    And No exception was thrown

  Scenario: Changing job name to unique one
  Try to edit job name to a unique one, leave description as it is.
  Kapua should not return any errors.

    Given I prepare a job with name "jobName" and description "jobDescription"
    When I create a new job entity from the existing creator
    Then I change name of job from "jobName" to "jobName1"
    And I search for the job in the database
    Then I find a job with name "jobName1"
    And No exception was thrown
    Then I search for the job in the database
    And There is no job with name "jobName" in database

  Scenario: Changing job name to non-unique one
  Try to edit job name to a non-unique one, leave description as it is.
  Kapua should return an error.

    Given I prepare a job with name "jobName" and description "jobDescription"
    When I create a new job entity from the existing creator
    Then I prepare a job with name "jobName1" and description "jobDescription"
    And I create a new job entity from the existing creator
    Given I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name jobName already exists."
    When I change name of job from "jobName1" to "jobName"
    And An exception was thrown

  Scenario: Changing job name to short one without description
  Try to edit job name so it is very short (e.g "job") but still is valid.
  Kapua should not return any errors.

    Given I prepare a job with name "jobName" and description ""
    When I create a new job entity from the existing creator
    Then I change name of job from "jobName" to "job"
    And I search for the job in the database
    Then I find a job with name "job"
    And No exception was thrown

  Scenario: Changing job name to a too short one without description
  Try to edit job name so it is too short (e.g "j").
  Kapua should return an error.

    Given I prepare a job with name "jobName" and description ""
    When I create a new job entity from the existing creator
    And I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument job.name: Value less than allowed min length. Min length is: 3."
    Then I change name of job from "jobName" to "j"
    And An exception was thrown

  Scenario: Changing job name to a long one without description
  Try to edit job name so it is 255 characters long without special symbols or numbers.
  Kapua should not return any errors.

    Given I prepare a job with name "jobName" and description ""
    When I create a new job entity from the existing creator
    Then I change the job name to "jobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejob"
    And I search for the job in the database
    Then I find a job with name "jobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejob"
    And No exception was thrown

  Scenario: Changing job name to a too long one without description
  Try to edit the job name so it is 256 characters long without special symbols or numbers.
  Kapua should return an error.

    Given I prepare a job with name "JjobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejobNamejob" and description ""
    Given I expect the exception "KapuaIllegalArgumentException" with the text "Value over than allowed max length. Max length is: 255."
    When I create a new job entity from the existing creator
    And An exception was thrown

  Scenario: Changing job name to contain permitted symbols in name without description
  Try to change job name so it contains permitted symbols (-,_).
  Kapua should not return any errors.

    When I try to update job name with permitted symbols "-_" in name
    And I search for the job in the database
    Then I find a job with name "jobName_"
    And No exception was thrown

  Scenario: Changing job name to contain invalid symbols in name without description
  Try to change job name so it contains invalid symbols.
  Kapua should return an error.

    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument job.name"
    When I try to update job name with invalid symbols "!#$%&'()=»Ç>:;<.,⁄@‹›€*ı–°·‚±Œ„‰?“‘”’ÉØ∏{}|ÆæÒÔÓÌÏÎÍÅ«" in name
    Then An exception was thrown

  Scenario: Changing job description to unique one
  Try to change a job description to unique one (e.g. "description 123").
  Kapua should not return any errors.

    Given I prepare a job with name "jobName" and description "jobDescription"
    Then I create a new job entity from the existing creator
    When I change the job description from "jobDescription" to "description123"
    Then I find a job with description "description123"
    And No exception was thrown

  Scenario: Changing job description to non-unique one
  Try to change a job description to non-unique one (e.g "jobDescription123").
  Kapua should not return any errors. Description can be non-unique.

    Given I prepare a job with name "jobName" and description "jobDescription"
    When I create a new job entity from the existing creator
    Then I prepare a job with name "jobName1" and description "jobDescription1"
    And I create a new job entity from the existing creator
    When I change the job description from "jobDescription" to "jobDescription"
    And No exception was thrown

  Scenario: Changing job description to very short one
  Try to change job description to very short one (e.g "d").
  Kapua should not return any errors. Description field is not limited downwards

    Given I prepare a job with name "jobName" and description "jobDescription"
    Then I create a new job entity from the existing creator
    And I change the job description to "j"
    Then I search for the job in the database
    When I find a job with description "j"
    Then No exception was thrown

  Scenario: Changing job description to the long one
  Try to edit description on a job with description that has 255 characters.
  Kapua should not return any errors.

    Given I prepare a job with name "jobName" and description "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondedescription"
    And I create a new job entity from the existing creator
    When I search for the job in the database
    Then I find a job with description "descriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondescriptiondedescription"
    And No exception was thrown

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
