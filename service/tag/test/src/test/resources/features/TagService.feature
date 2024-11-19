###############################################################################
# Copyright (c) 2017, 2022 Eurotech and/or its affiliates and others
#
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#     Eurotech
###############################################################################
@tag
@env_none

Feature: Tag Service
  Tag Service is responsible for CRUD operations on Tags. This service is currently
  used to attach tags to Devices, but could be used to tag any kapua entity, like
  User for example.

  @setup
  @KapuaProperties("locator.class.impl=org.eclipse.kapua.qa.common.MockedLocator")
  Scenario: Initialize test environment
    Given Init Security Context

  Scenario: Creating Unique Tag Without Description
  Create a tag with unique name without description. Kapua should not return any error.

    Given A tag with name "Tag123" is created
    When Tag with name "Tag123" is searched
    Then I find a tag with name "Tag123"

  Scenario: Creating Non-unique Tag Without Description
  Create a tag with non-unique name without description. Kapua should return Exception.

    Given I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name Tag123 already exists."
    When I create tag with name "Tag123"
    And I create tag with name "Tag123"
    Then An exception was thrown

  Scenario: Creating Tag With Short Name Without Description
  Create a tag with short name without description. Kapua should not return any errors.

    Given A tag with name "abc" is created
    When Tag with name "abc" is searched
    Then I find a tag with name "abc"

  Scenario: Creating Tag With Too Short Name Without Description
  Create a tag with too short name without description. Kapua should return Exception.

    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument tagCreator.name: Value less than allowed min length. Min length is: 3."
    When I create tag with name "a"
    Then An exception was thrown

  Scenario: Creating Tag With Long Name Without Description
  Create a tag with long (255 characters) name without description. Kapua should not return any errors.

    Given A tag with name "Y5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh" is created
    When Tag with name "Y5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh" is searched
    Then I find a tag with name "Y5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh"

  Scenario: Creating Tag With Too Long Name Without Description
  Create a tag with too long (256 characters) name without description. Kapua should return Exception.

    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument tagCreator.name: Value over than allowed max length. Max length is: 255."
    When I create tag with name "aY5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh"
    Then An exception was thrown

  Scenario: Creating Tag With Permitted Symbols In Name Without Description
  Create a tag name with permitted ('-' and '_') symbols without description. Kapua should not return any errors.

    Given A tag with name "Tag-12_3" is created
    When Tag with name "Tag-12_3" is searched
    Then I find a tag with name "Tag-12_3"

  Scenario: Creating Tag With Invalid Symbols In Name Without Description
  Try to create a tag name with invalid symbols without description. Kapua should return Exception.

    Given I expect the exception "KapuaIllegalArgumentException" with the text "*"
    When I try to create tags with that include invalid symbols in name
    Then An exception was thrown

  Scenario: Creating Tag Without a Name And Without Description
  Create a tag witout a name and without a description. Kapua should return an error.

    Given I expect the exception "Exception"
    When I create tag with name ""
    Then An exception was thrown

  Scenario: Creating Tag With Numbers In Name Without Description
  Create a tag with numbers in name without description. Kapua should not return any errors.

    Given A tag with name "0123456789" is created
    When Tag with name "0123456789" is searched
    Then I find a tag with name "0123456789"

  Scenario: Creating Unique Tag With Unique Description
  Create a tag with unique name and unique description. Kapua should not return any errors.

    Given I create tag with name "Tag1" and description "Description-@12#$456"
    When Tag with name "Tag1" is searched
    Then I find a tag with name "Tag1"

  Scenario: Creating Unique Tag With Non-unique Description
  Create two unique tags with same description. Kapua should not return any errors.

    Given I create tag with name "Tag123" and description "Description1"
    And I create tag with name "Tag456" and description "Description1"
    When Tag with name "Tag123" is searched
    Then I find a tag with name "Tag123"

  Scenario: Creating Non-Unique Tag With Valid Description
  Create non-unique tag with valid description. Kapua should throw Exception.

    Given I expect the exception "KapuaDuplicateNameException"
    When I create tag with name "Tag123" and description "Description1"
    And I create tag with name "Tag123" and description "Description1"
    Then An exception was thrown

  Scenario: Creating Tag With Short Name With Valid Description
  Try to create tag with short name with valid Description. Kapua should not return any errors.

    Given I create tag with name "Tag" and description "Valid description 123"
    When Tag with name "Tag" is searched
    Then I find a tag with name "Tag"

  Scenario: Creating Tag With Too Short Name With Valid Description
  Try to create tag with too short name with valid description.Kapua should throw Exception.

    Given I expect the exception "Exception"
    When I create tag with name "t" and description "Valid description 123"
    Then An exception was thrown

  Scenario: Creating Tag With Long Name With Valid Description
  Try to create tag with long name with valid description. Kapua should not return any errors.

    Given I create tag with name "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj" and description "Valid description 123"
    When Tag with name "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj" is searched
    Then I find a tag with name "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj"

  Scenario: Creating Tag With Too Long Name With Valid Description
  Try to create tag with too long name with valid description. Kapua should throw Exception.

    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument tagCreator.name: Value over than allowed max length. Max length is: 255."
    When I create tag with name "aoAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj" and description "Valid description 123"
    Then An exception was thrown

  Scenario: Creating Tag With Permitted Symbols In Name With Valid Description
  Try to create tag with permitted symbols in name with valid description. Kapua should not return any errors.

    Given I create tag with name "Tag_12-3" and description "Valid description 123"
    When Tag with name "Tag_12-3" is searched
    Then I find a tag with name "Tag_12-3"

  Scenario: Creating Tag With Invalid Symbols In Name With Valid Description
  Try to create a tag with invalid symbols with valid description. Kapua should throw Exception.

    Given I expect the exception "Exception"
    When I create tag with name "Tag@123" and description "Valid description 123"
    Then An exception was thrown

  Scenario: Creating Tag Without a Name And With Valid Description
  Try to create a tag without a name with valid description. Kapua should throw Exception.

    Given I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "" and description "Valid description 123"
    Then An exception was thrown

  Scenario: Creating Tag With Numbers In Name With Valid Description
  Try to create a tag with numbers in name with valid description. Kapua should not return any errors.

    Given I create tag with name "0123456789" and description "Valid-description@33-2"
    And Tag with name "0123456789" is searched
    Then I find a tag with name "0123456789"

  Scenario: Creating Unique Tag With Short Description
  Try to create a tag with short description. Kapua should not return any errors.

    Given I create tag with name "Tag123" and description "a"
    When Tag with name "Tag123" is searched
    Then I find a tag with name "Tag123"

  Scenario: Creating Unique Tag With Long Description
  Try to create a tag with long description. Kapua should not return any errors.

    Given I create tag with name "Tag123" and description "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj"
    When Tag with name "Tag123" is searched
    Then I find a tag with name "Tag123"

  Scenario: Changing Tag's Name To Unique One
  Try to edit tag's name into a unique one. Kapua should not return any errors.

    Given I create tag with name "Tag1" without description
    When Name of tag "Tag1" is changed into "Tag2"
    And Tag with name "Tag2" is searched
    Then I find a tag with name "Tag2"
    When Tag with name "Tag1" is searched
    Then Tag with name "Tag1" is not found

  Scenario: Changing Tag's Name To Non-Unique One
  Try to edit tag's name to non-unique one. Kapua should throw Exception.

    When I create tag with name "Tag1" without description
    And I create tag with name "Tag2" without description
    Given I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name Tag1 already exists."
    When Name of tag "Tag2" is changed into "Tag1"
    Then An exception was thrown

  Scenario: Changing Tag's Name To Short One Without Description
  Try to edit tag's name to short one. Kapua should not return any errors.

    Given I create tag with name "Tag1" without description
    When Name of tag "Tag1" is changed into "abc"
    And Tag with name "abc" is searched
    Then I find a tag with name "abc"
    When Tag with name "Tag1" is searched
    Then Tag with name "Tag1" is not found

  Scenario: Changing Tag's Name To a Too Short One Without Description
  Try to edit tag's name to a too short one. Kapua should throw Exception.

    When I create tag with name "Tag1" without description
    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument tag.name: Value less than allowed min length. Min length is: 3."
    When Tag name is changed into name "a"
    Then An exception was thrown

  Scenario: Changing Tag's Name To a Long One Without Description
  Try to edit tag's name to a long (255 characters) one. Kapua should not return any errors.

    Given I create tag with name "Tag1" without description
    When Name of tag "Tag1" is changed into "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX"
    And Tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" is searched
    Then I find a tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX"
    When Tag with name "Tag1" is searched
    Then Tag with name "Tag1" is not found

  Scenario: Changing Tag's Name To a Too Long One Without Description
  Try to edit tag's name to a too long (256 characters) one. Kapua should throw Exception.

    When I create tag with name "Tag1" without description
    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument tag.name: Value over than allowed max length. Max length is: 255."
    When Name of tag "Tag1" is changed into "aYXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX"
    Then An exception was thrown

  Scenario: Changing Tag's Name To Contain Permitted Symbols In Name Without Description
  Try to edit tag's name to a name with permitted symbols. Kapua should not return any errors.

    Given I create tag with name "Tag1" without description
    When Tag name is changed into name "T-a-g_1"
    And Tag with name "T-a-g_1" is searched
    Then I find a tag with name "T-a-g_1"

  Scenario: Changing Tag's Name To Contain Invalid Symbols In Name Without Description
  Try to edit tag's name to a name with invalid symbols. Kapua should throw Exception.

    When I create tag with name "Tag1" without description
    Given I expect the exception "KapuaIllegalArgumentException" with the text "An illegal value was provided for the argument tag.name: Tag@1#2?*=)3."
    When Name of tag "Tag1" is changed into "Tag@1#2?*=)3"
    Then An exception was thrown

  Scenario: Deleting Tag's Name And Leaving It Empty Without Description
  Try to edit tag's name to an empty name. Kapua should throw Exception, name is mandatory.

    When I create tag with name "Tag1" without description
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    When Name of tag "Tag1" is changed into ""
    Then An exception was thrown

  Scenario: Editing Tag's Name To Contain Numbers Without Description
  Try to edit tag's name to a name that contains numbers. Kapua should not return any errors.

    Given I create tag with name "Tag1" without description
    When Name of tag "Tag1" is changed into "Tag0123456789"
    And Tag with name "Tag0123456789" is searched
    Then I find a tag with name "Tag0123456789"
    When Tag with name "Tag1" is searched
    Then Tag with name "Tag1" is not found

  Scenario: Changing Tag's Description To Unique One
  Try to edit tag's description so it stays unique. Kapua should not return any errors.

    Given I create tag with name "Tag1" without description
    When Description of tag "Tag1" is changed into "Valid description 123"
    Then No exception was thrown
    When I create tag with name "Tag2" and description "Description for testing"
    And Description of tag "Tag2" is changed into "Description not for testing anymore"
    Then No exception was thrown

  Scenario: Changing Tag's Description To Non-Unique One
  Try to edit tag's description to a non-unique one. Kapua should not return any errors.

    Given I create tag with name "Tag1" and description "Description 123"
    When I create tag with name "Tag2" and description "Description 567"
    And Description of tag "Tag2" is changed into "Description 123"
    Then No exception was thrown

  Scenario: Changing Description On Tag With Short Name
  Try to edit description on a tag with too short name. Kapua should not throw any errors.

    Given I create tag with name "abc" without description
    When Description of tag "abc" is changed into "Description 123"
    Then No exception was thrown

  Scenario: Changing Description On Tag With Long Name
  Try to edit description on a tag with long name. Kapua should not return any errors.

    Given I create tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" and description "Description"
    When Description of tag "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" is changed into "Description 123"
    And Tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" is searched
    Then I find a tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX"

  Scenario: Changing Description On Tag With Permitted Symbols In Name
  Try to edit description on a tag with permitted symbols. Kapua should not return any errors.

    Given I create tag with name "T_a_g-1" without description
    When Description of tag "T_a_g-1" is changed into "Description 123"
    Then No exception was thrown

  Scenario: Changing Description On Tag With Numbers In Name
  Try to edit description on a tag with numbers in its name. Kapua should not return any errors.

    Given I create tag with name "Tag123" and description "Description"
    When Description of tag "Tag123" is changed into "Description 123"
    Then No exception was thrown
    When Tag with name "Tag123" is searched
    Then I find a tag with name "Tag123"

  Scenario: Changing Description On Tag With Short Description
  Try to edit description on a tag with short description. Kapua should not return any errors.

    Given I create tag with name "Tag1" and description "a"
    When Description of tag "Tag1" is changed into "b"
    Then No exception was thrown

  Scenario: Changing Description On Tag With Long Description
  Try to edit description on a tag with long (255 characters) description. Kapua should not return any errors.

    Given I create tag with name "Tag1" and description "mrZ4vBeOJbGkSlfzSHMY3Dj7gLO3E5SZFrtv7X4RF5LX1OWhRhBaRPubBJSglhS9ueguyStqJOcDs49mMVyuM2E08aPxcAMasSi6KWXmRcQaXl99oyFTScQT4ILK7I7EKuWFArivwLZkEPeK52OKnZjLxer8WGQ88CDqrooUUYt0lIOytrAGftGBO69DcIEjFrs73Mgyec0MvKkVeYYQ3dzDez2tGHPRTx19TVxHGtem52JOT6H7g0I3eGX5Ju0"
    When Tag description is changed into "Description 123"
    Then No exception was thrown

  Scenario: Deleting existing tag
  Create a tag and after that try to delete it. Kapua should not return any errors.

    Given I create tag with name "Tag1" without description
    When I create tag with name "Tag2" and description "Tag with description"
    And I delete tag with name "Tag1"
    And I delete tag with name "Tag2"
    When Tag with name "Tag1" is searched
    Then No tag was found
    When Tag with name "Tag2" is searched
    Then No tag was found

  Scenario: Deleting Non-Existent Tag
  Try to delete an non-existent tag. Kapua should throw Exception.

    Given I create tag with name "Tag1" without description
    When I delete tag with name "Tag1"
    And Tag with name "Tag1" is searched
    Given I expect the exception "NullPointerException" with the text "*"
    When I delete tag with name "Tag1"
    Then An exception was thrown

  Scenario: Deleting Existing Tag And Creating It Again With Same Name
  Delete an existing tag and creating it again with the same name. Kapua should not throw any errors.

    Given I create tag with name "Tag1" without description
    When I delete tag with name "Tag1"
    And I create tag with name "Tag1" without description
    And Tag with name "Tag1" is searched
    Then I find a tag with name "Tag1"
    And No exception was thrown

  Scenario: Adding Regular Tag Without Description To Device
  Create a tag. Go to devices, select a device and add created tag to it. Kapua should not return any errors.

    Given I create tag with name "Tag123" without description
    And I create a device with name "Device1"
    When I assign tag "Tag123" to device "Device1"
    Then Tag "Tag123" is assigned to device "Device1"
    And No exception was thrown

  Scenario: Adding Tag With Long Name Without Description To Device
  Create a tag with long (255 characters) name. Go to devices, select a device and add created tag to it. Kapua should not return any errors.

    Given A device named "Device1"
    And I create tag with name "FxJpmQN9CU3ruFCAGtPDmKymN88CK7rn5L1AAYH184hCaxEpJsOQWKc3ACV2Gw44yWFz0o74rnsCabGHmX7azzplDPAe4mVYmHGLnMmlliQUpljJYB5i1Wq4flevCI8lIjZQ7UT7ll6I2C4eqvhXmt4GOD50bhiLzMDDZJeXXC8IjCidnz60QmbzUxpRC1YP8MQqosesjER2xm4jPrk3eH0egSwxvnPCeAWTXtSHeejOFVKLL78IW1xlhXkbOCh" without description
    When I assign tag "FxJpmQN9CU3ruFCAGtPDmKymN88CK7rn5L1AAYH184hCaxEpJsOQWKc3ACV2Gw44yWFz0o74rnsCabGHmX7azzplDPAe4mVYmHGLnMmlliQUpljJYB5i1Wq4flevCI8lIjZQ7UT7ll6I2C4eqvhXmt4GOD50bhiLzMDDZJeXXC8IjCidnz60QmbzUxpRC1YP8MQqosesjER2xm4jPrk3eH0egSwxvnPCeAWTXtSHeejOFVKLL78IW1xlhXkbOCh" to device "Device1"
    Then Tag "FxJpmQN9CU3ruFCAGtPDmKymN88CK7rn5L1AAYH184hCaxEpJsOQWKc3ACV2Gw44yWFz0o74rnsCabGHmX7azzplDPAe4mVYmHGLnMmlliQUpljJYB5i1Wq4flevCI8lIjZQ7UT7ll6I2C4eqvhXmt4GOD50bhiLzMDDZJeXXC8IjCidnz60QmbzUxpRC1YP8MQqosesjER2xm4jPrk3eH0egSwxvnPCeAWTXtSHeejOFVKLL78IW1xlhXkbOCh" is assigned to device "Device1"
    And No exception was thrown

  Scenario: Adding Tag With Short Name Without Description To Device
  Create a tag with short (3) name. Go to devices, select a device and add created tag to it. Kapua should not return any errors.

    Given A device named "Device1"
    And I create tag with name "abc" without description
    When I assign tag "abc" to device "Device1"
    Then Tag "abc" is assigned to device "Device1"
    And No exception was thrown

  Scenario: Adding Tag With Special Symbols Without Description To Device
  Create a tag with name that contains permitted special symbols. Go to devices, select a device and add created tag to it. Kapua should not return any errors.

    Given A device named "Device1"
    And I create tag with name "T-a-g_1_" without description
    When I assign tag "T-a-g_1_" to device "Device1"
    Then Tag "T-a-g_1_" is assigned to device "Device1"
    And No exception was thrown

  Scenario: Adding Tag With Numbers Without Description To Device
  Create a tag with name that contains numbers. Go to devices, select a device and add created tag to it. Kapua should not return any errors.

    Given A device named "Device1"
    And I create tag with name "Tag1234567890" without description
    When I assign tag "Tag1234567890" to device "Device1"
    Then Tag "Tag1234567890" is assigned to device "Device1"
    And No exception was thrown

  Scenario: Deleting Tag From Device
  Create a tag. Go to devices, select a device and add created tag to it.
  Kapua should not return any errors. Go to devices, select tag and remove it from selected device.
  Check if tag is removed.

    Given A device named "Device1"
    And I create tag with name "Tag1" without description
    When I assign tag "Tag1" to device "Device1"
    Then Tag "Tag1" is assigned to device "Device1"
    And No exception was thrown
    Given I unassign tag "Tag1" from device "Device1"
    Then Tag "Tag1" is not assigned to device "Device1"

  Scenario: Adding Previously Deleted Tag From Device Again
  Create a tag. Go to devices, select a device and add created tag to it.
  Kapua should not return any errors. Go to devices, select tag and remove it from selected device.
  Check if tag is removed. Assign the removed tag to device again.
  Kapua should not return any errors.

    Given A device named "Device1"
    And I create tag with name "Tag1" without description
    When I assign tag "Tag1" to device "Device1"
    Then Tag "Tag1" is assigned to device "Device1"
    And No exception was thrown
    Given I unassign tag "Tag1" from device "Device1"
    When Tag "Tag1" is not assigned to device "Device1"
    Given I assign tag "Tag1" to device "Device1"
    And Tag "Tag1" is assigned to device "Device1"
    Then No exception was thrown

  Scenario: Adding "Empty" Tag To Device
  Try to add non existent tag without description to a device. Kapua should throw Exception.

    Given A device named "Device1"
    And I expect the exception "NullPointerException" with the text "*"
    When I assign tag "Tag1" to device "Device1"
    Then An exception was thrown

  Scenario: Creating Tag With An Existing Name
  Try to create tag with an existing name. Kapua should throw Exception.

    Given I expect the exception "KapuaDuplicateNameException"
    When I create tag with name "Tag"
    And I create tag with name "Tag"
    Then An exception was thrown

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
