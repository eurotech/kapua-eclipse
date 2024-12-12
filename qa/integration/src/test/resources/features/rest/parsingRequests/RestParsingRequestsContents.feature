###############################################################################
# Copyright (c) 2018, 2022 Eurotech and/or its affiliates and others
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
@rest_parsing

Feature: REST API tests for parsing of requests
  REST API tests to verify correct responses upon parsing of wrong format fields in requests

  @setup
  Scenario: Initialize security context, then start rest-api container and dependencies
    Given Init Jaxb Context
    And Init Security Context
    And start rest-API container and dependencies with auth token TTL "10000"ms and refresh token TTL "20000"ms and cors endpoint refresh interval 5s

  Scenario: Creation of a device with a wrong format "status" field
    api back-end parser (MOXy) should spot error on the format and the mico-service should reply with 400 error code

    Given Server with host "127.0.0.1" on port "8081"
    Given An authenticated user
    When REST "POST" call at "/v1/_/devices" with JSON "{\"clientId\": \"wrongStatusDevice\", \"status\": \"FOOOO\"}"
    Then REST response code is 400
    And REST response containing text "An error occurred during the parsing of the XML/JSON"

  Scenario: Update of "credentialService" configuration missing to include the "type" field but providing the "value" field
    api back-end parser (MOXy) should spot error on the format and the mico-service should reply with 400 error code
    Given Server with host "127.0.0.1" on port "8081"
    Given An authenticated user
    When REST "PUT" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON "{\"id\": \"org.eclipse.kapua.service.authentication.credential.CredentialService\", \"properties\": {\"property\": [{\"name\": \"password.minLength\", \"array\": false, \"encrypted\": false, \"value\": [\"13\"]}]}}"
    Then REST response code is 400
    And REST response containing text "An error occurred during the parsing of the XML/JSON"
    And REST response containing text "Illegal 'null' value for 'property.type' for parameter: password.minLength"

  Scenario: Update of an user setting a wrong format "expirationDate" field
  api back-end parser (MOXy) should spot error on the format and the micro-service should reply with 400 error code
    Given Server with host "127.0.0.1" on port "8081"
    Given An authenticated user
    #now let's try to update kapua-broker with a not parsable expiration date
    When REST "PUT" call at "/v1/_/users/Ag" with JSON "{\"optlock\": 1, \"name\": \"kapua-broker\", \"expirationDate\": \"randomwrongvaluenotparsabledate\"}"
    Then REST response code is 400
    And REST response containing text "An error occurred during the parsing of the XML/JSON"

  Scenario: Update of "credentialService" configuration missing to include the "type" field AND the "value" field
  api back-end parser (MOXy) should NOT spot error because we are trying to update a property with a "default" value
    Given Server with host "127.0.0.1" on port "8081"
    Given An authenticated user
    #the json is a huge string but basically it's a complete set of properties for the CredentialService, where the "password.minLength" property we want to set has a finite value (123)
    When REST "PUT" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON "{\"id\": \"org.eclipse.kapua.service.authentication.credential.CredentialService\", \"properties\": {\"property\": [{\"name\": \"lockoutPolicy.resetAfter\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3800\"]}, {\"name\": \"password.minLength\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"123\"]}, {\"name\": \"lockoutPolicy.lockDuration\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"10800\"]}, {\"name\": \"lockoutPolicy.enabled\", \"array\": false, \"encrypted\": false, \"type\": \"Boolean\", \"value\": [\"true\"]}, {\"name\": \"lockoutPolicy.maxFailures\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3\"]}]}}"
    Then REST response code is 204
    When REST "GET" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON ""
    Then REST response containing text "{\"name\":\"password.minLength\",\"array\":false,\"encrypted\":false,\"type\":\"Integer\",\"value\":[\"123\"]}"
      #the json is a huge string but basically it's a complete set of properties for the CredentialService, where the "password.minLength" property we want to set has missing "type" and "value" fields (we want to set an unlimited value for it)
    When REST "PUT" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON "{\"id\": \"org.eclipse.kapua.service.authentication.credential.CredentialService\", \"properties\": {\"property\": [{\"name\": \"lockoutPolicy.resetAfter\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3800\"]}, {\"name\": \"password.minLength\", \"array\": false, \"encrypted\": false}, {\"name\": \"lockoutPolicy.lockDuration\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"10800\"]}, {\"name\": \"lockoutPolicy.enabled\", \"array\": false, \"encrypted\": false, \"type\": \"Boolean\", \"value\": [\"true\"]}, {\"name\": \"lockoutPolicy.maxFailures\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3\"]}]}}"
    Then REST response code is 204
    #and now if I get the configuration there will be no value for the password.minLength (aka it's the default one)
    When REST "GET" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON ""
    Then REST response containing text "{\"name\":\"password.minLength\",\"array\":false,\"encrypted\":false},{"

    Scenario: Update of "credentialService" configuration using properly type but with a "" value cause I want to set a default value for a property.
      Given Server with host "127.0.0.1" on port "8081"
      Given An authenticated user
          #this is the json above but in the password.minLength now I set type and a finite value (123)
      When REST "PUT" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON "{\"id\": \"org.eclipse.kapua.service.authentication.credential.CredentialService\", \"properties\": {\"property\": [{\"name\": \"lockoutPolicy.resetAfter\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3800\"]}, {\"name\": \"password.minLength\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"123\"]}, {\"name\": \"lockoutPolicy.lockDuration\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"10800\"]}, {\"name\": \"lockoutPolicy.enabled\", \"array\": false, \"encrypted\": false, \"type\": \"Boolean\", \"value\": [\"true\"]}, {\"name\": \"lockoutPolicy.maxFailures\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3\"]}]}}"
      Then REST response code is 204
      When REST "GET" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON ""
      Then REST response containing text "{\"name\":\"password.minLength\",\"array\":false,\"encrypted\":false,\"type\":\"Integer\",\"value\":[\"123\"]}"
          #this is the json above but in the password.minLength now I set type and a "" value to restore property to the default value
      When REST "PUT" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON "{\"id\": \"org.eclipse.kapua.service.authentication.credential.CredentialService\", \"properties\": {\"property\": [{\"name\": \"lockoutPolicy.resetAfter\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3800\"]}, {\"name\": \"password.minLength\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"\"]}, {\"name\": \"lockoutPolicy.lockDuration\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"10800\"]}, {\"name\": \"lockoutPolicy.enabled\", \"array\": false, \"encrypted\": false, \"type\": \"Boolean\", \"value\": [\"true\"]}, {\"name\": \"lockoutPolicy.maxFailures\", \"array\": false, \"encrypted\": false, \"type\": \"Integer\", \"value\": [\"3\"]}]}}"
      Then REST response code is 204
      #and now if I get the configuration there will be no value for the password.minLength (aka it's the default one)
      When REST "GET" call at "/v1/_/serviceConfigurations/org.eclipse.kapua.service.authentication.credential.CredentialService" with JSON ""
      Then REST response containing text "{\"name\":\"password.minLength\",\"array\":false,\"encrypted\":false},{"


  @teardown
  Scenario: Stop full docker environment
    Given Stop full docker environment
    And Clean Locator Instance


