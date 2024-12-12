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
@env_none

#this feature file is similar to the one created for account service but located under service > account, this one is more focused on the creation of accounts rather that findings of / query of

Feature: Account Service Tests

  @setup
  Scenario: Initialize test environment
    Given Init Jaxb Context
    And Init Security Context

  Scenario: Creating A Valid Account
  Login as kapua-sys, create an account with all valid fields
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "account-1", organization name "organization" and email address "org@abc.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating An Account With Unique Name
  Login as kapua-sys, create two accounts with different names
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "account-1", organization name "organization1" and email address "org1@abc.com"
    And I select account "kapua-sys"
    When I create an account with name "account-2", organization name "organization2" and email address "org2@abc.com"
    Then No exception was thrown
    And I logout


  Scenario: Creating An Account With Non-unique Name
  Login as kapua-sys, create an account and create another one with same name
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "account-1", organization name "organization" and email address "org@abc.com"
    And I select account "kapua-sys"
    Given I expect the exception "KapuaDuplicateNameException" with the text "*"
    When I create an account with name "account-1", organization name "organization2" and email address "org2@abc.com"
    Then An exception was thrown
    And I logout

  Scenario: Creating An Account With Numbers And Valid Symbols In Name
  Login as kapua-sys, create an account with numbers and '-' in name
  No exception should be thrown, dash and numbers are allowed

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "1231-2323", organization name "organization" and email address "org@abc.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating An Account Without Name
  Login as kapua-sys, try to create an account without name
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    When I create an account with name "", organization name "org" and email address "org@org.com"
    Then An exception was thrown
    And I logout

  Scenario: Creating An Account With Short Name
  Login as kapua-sys, try to create an account with name that only has 3 characters
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "abc", organization name "organization" and email address "org@abc.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating An Account With Long Name
  Login as kapua-sys, try to create an account with name that has 50 characters
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "7j5w5HFyvkWta6W3pr6c35ihjHUxNVkcEovzXyySjKqWhsXbe3", organization name "organization" and email address "org@abc.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating An Account Without Organization Name
  Login as kapua-sys, try to create an account without organization name
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    When I create an account with name "acc1", organization name "" and email address "org@abc.com"
    Then An exception was thrown
    And I logout

  Scenario: Creating An Account With Short Organization Name
  Login as kapua-sys, try to create an account with organization name that only has 1 character
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "acc1", organization name "o" and email address "org@abc.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating An Account With Long Organization Name
  Login as kapua-sys, try to create an account with organization name that has 255 characters
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "acc1", organization name "70PhDFZYDvBRNWU3J0rLqXa7ynQs0ZcjI9BXILV8ufsdvr3JtR07nxjvbaqPAlQVEOGjpopecZaBVTmrzw45ARl64Alw2QNjVxbRp56lJTxCGePcys0PLj4ZbQSmi8xdUVOQsNn5WDd6xx1lt3OXsugq77tG9dbaheeQTWvaMpri9gDL61uS5O8me4YXQ6AMkNQZxwuibsk3ohsGBSN9Z5ahmBeCCgTZulFXjdiHABaDIEiTM8qH05hhWmTs9jp" and email address "org@abc.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating An Account With Too Long Organization Name
  Login as kapua-sys, try to create an account with organization name that has 256 characters
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I expect the exception "KapuaException" with the text "*"
    When I create an account with name "acc1", organization name "a70PhDFZYDvBRNWU3J0rLqXa7ynQs0ZcjI9BXILV8ufsdvr3JtR07nxjvbaqPAlQVEOGjpopecZaBVTmrzw45ARl64Alw2QNjVxbRp56lJTxCGePcys0PLj4ZbQSmi8xdUVOQsNn5WDd6xx1lt3OXsugq77tG9dbaheeQTWvaMpri9gDL61uS5O8me4YXQ6AMkNQZxwuibsk3ohsGBSN9Z5ahmBeCCgTZulFXjdiHABaDIEiTM8qH05hhWmTs9jp" and email address "org@abc.com"
    Then An exception was thrown
    And I logout

  Scenario: Creating An Account With Special Symbols In Organization Name
  Login as kapua-sys, try to create an account with organization name that contains special symbols
  No exception should be thrown as all characters are allowed for contact name

    Given I login as user with name "kapua-sys" and password "kapua-password"
    When I create an account with name "acc1", organization name "org@#$%&/!)=?(" and email address "org@abc.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating An Account With Wrong TLD Format In Email
  Login as kapua-sys, try to create an account with wrong TLD (less than 2 or more than 63 characters)
  Exceptions should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Given I expect the exception "KapuaIllegalArgumentException" with the text "*"
    When I create an account with name "acc1", organization name "org1" and email address "org@abc.commmcommmcommmcommmcommmcommmcommmcommmcommmcommmcommmcommmcommm"
    Then An exception was thrown
    And I select account "kapua-sys"
    Given I expect the exception "KapuaIllegalArgumentException" with the text "*"
    When I create an account with name "acc2", organization name "org2" and email address "org@abc.c"
    Then An exception was thrown
    And I logout

  Scenario: Creating And Account Without "@" In Email
  Login as kapua-sys, try to create an account without '@' in email
  Exceptions should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I expect the exception "KapuaIllegalArgumentException" with the text "*"
    When I create an account with name "acc1", organization name "org1" and email address "orgabc.com"
    Then An exception was thrown
    And I logout

  Scenario: Creating And Account Without "." In Email
  Login as kapua-sys, try to create an account without '.' in email
  Exceptions should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I expect the exception "KapuaIllegalArgumentException" with the text "*"
    When I create an account with name "acc1", organization name "org1" and email address "org@abccom"
    Then An exception was thrown
    And I logout

  Scenario: Creating An Account Without Email
  Login as kapua-sys, try to create an account without email
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    When I create an account with name "acc1", organization name "org1" and email address ""
    Then An exception was thrown
    And I logout

  Scenario: Creating Sub-accounts when InfiniteChildAccounts Is Set To True
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to true
  Try to create a few sub-accounts under created account
  All accounts should be created

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then I select account "acc1"
    And I create an account with name "acc12", organization name "acc12" and email address "acc12@org.com"
    Then I select account "acc1"
    And I create an account with name "acc13", organization name "acc13" and email address "acc13@org.com"
    Then No exception was thrown
    And I logout

  Scenario: Creating Sub-accounts When InfiniteChildAccounts Is Set To False
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to false
  Try to create a few sub-accounts under created account
  No accounts should be created

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I expect the response status code 403
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then An exception was thrown
    And Response status code match
    Then I logout

  Scenario: Creating Sub-accounts When InfiniteChildAccounts Is Set To True And maxNumberChildAccounts Is Set
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to true and maxNumberChildAccounts To 1
  Try to create a few (more than one) sub-accounts under created account
  All accounts should be created because we allow infinite child accounts so maxNumberChildAccounts value does not matter

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 1     |
    Then I select account "acc1"
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then I select account "acc1"
    And I create an account with name "acc12", organization name "acc12" and email address "acc12@org.com"
    Then I select account "acc1"
    And I create an account with name "acc13", organization name "acc13" and email address "acc13@org.com"
    Then No exception was thrown
    When I query for all sub-accounts in "acc1"
    Then I find 3 accounts
    And I logout

  Scenario: Creating Sub-accounts When InfiniteChildAccounts Is Set To False And maxNumberChildAccounts Is Set
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to true and maxNumberChildAccounts To 1
  Try to create a few sub-accounts under created account
  Only 1 account is created  because infiniteChildAccounts is set to false so maximum number of child account is 1

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 1     |
    Then I select account "acc1"
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then I select account "acc1"
    Given I expect the exception "KapuaMaxNumberOfItemsReachedException" with the text "*"
    And I create an account with name "acc12", organization name "acc12" and email address "acc12@org.com"
    Then An exception was thrown
    When I query for all sub-accounts in "acc1"
    Then I find 1 account
    And I logout

  Scenario: Setting InfiniteChildAccounts To False When Sub-accounts Are Already Created
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to true, maxNumberChildAccounts stays at 0
  Create a few sub-accounts
  Again configure AccountService of account, set infiniteChildAccounts to false, maxNumberChildAccounts stays at 0
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then I select account "acc1"
    And I create an account with name "acc12", organization name "acc12" and email address "acc12@org.com"
    When I query for all sub-accounts in "acc1"
    Then I find 2 accounts
    Then I select account "acc1"
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "The maximum of resources for the org.eclipse.kapua.service.account.AccountService service for the account"
    When I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Decreasing MaxNumberChildAccounts When Sub-accounts Are Already Created
  Login as kapua-sys, create an account
  Configure AccountService of that account, set maxNumberChildAccounts to 1, infiniteChildAccounts stays at false
  Create a sub-account
  Again configure AccountService of account, set maxNumberChildAccounts to 0, infiniteChildAccounts stays at false
  Exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then I select account "acc1"
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then I select account "acc1"
    And I create an account with name "acc12", organization name "acc12" and email address "acc12@org.com"
    When I query for all sub-accounts in "acc1"
    Then I find 2 accounts
    Then I select account "acc1"
    Given I expect the exception "ServiceConfigurationLimitExceededException" with the text "The maximum of resources for the org.eclipse.kapua.service.account.AccountService service for the account"
    When I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 0     |
    Then An exception was thrown
    And I logout

  Scenario: Setting InfiniteChildAccounts To False And Increasing MaxNumberChildAccounts When Sub-accounts Are Already Created
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to true and MaxNumberChildAccounts to 0
  Create 2 sub-accounts
  Again configure AccountService of account, set infiniteChildAccounts to false and MaxNumberChildAccounts to 2
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Then I select account "acc1"
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then I select account "acc1"
    And I create an account with name "acc12", organization name "acc12" and email address "acc12@org.com"
    When I query for all sub-accounts in "acc1"
    Then I find 2 accounts
    Then I select account "acc1"
    When I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then No exception was thrown
    And I logout

  Scenario: Setting InfiniteChildAccounts To True And Decreasing MaxNumberChildAccounts When Sub-accounts Are Already Created
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to false and MaxNumberChildAccounts to 2
  Create 2 sub-accounts
  Again configure AccountService of account, set infiniteChildAccounts to true and MaxNumberChildAccounts to 0
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | false |
      | integer | maxNumberChildEntities | 2     |
    Then I select account "acc1"
    And I create an account with name "acc11", organization name "acc11" and email address "acc11@org.com"
    Then I select account "acc1"
    And I create an account with name "acc12", organization name "acc12" and email address "acc12@org.com"
    When I query for all sub-accounts in "acc1"
    Then I find 2 accounts
    Then I select account "acc1"
    When I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    Then No exception was thrown
    And I logout

  Scenario: Creating 100 Sub-accounts While InfiniteChildAccounts Is Set To True
  Login as kapua-sys, create an account
  Configure AccountService of that account, set infiniteChildAccounts to true
  Create 100 sub-accounts
  No exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    Then I create an account with name "acc1", organization name "acc1" and email address "acc1@org.com"
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 0     |
    When I create 100 accounts in current scopeId
    Then No exception was thrown
    And I logout

  @teardown
  Scenario: Reset Security Context for all scenarios
    Given Clean Locator Instance
    And Reset Security Context
