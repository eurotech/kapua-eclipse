###############################################################################
# Copyright (c) 2021, 2024 Eurotech and/or its affiliates and others
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
@env_docker
@it
@jobEngine
@jobEngineStepDefinitions
@deviceManagementKeystore

Feature: Job Engine Service - Keystore Step Definitions

  @setup
  Scenario: Setup test resources
    Given Init Security Context
    And Start Docker environment with resources
      | db                  |
      | events-broker       |
      | job-engine          |
      | message-broker      |
      | broker-auth-service |
      | consumer-lifecycle  |

  #
  # Tests
  #

  Scenario: Running a Job with Keystore Certificate Create Step Definition

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 1 event within 30 seconds
    And The type of the last event is "BIRTH"
    Given I create a job with the name "TestJob - Keystore Steps"
    And I create a new job target item
    And Search for step definition with the name "Keystore Certificate Create"
    And I prepare a JobStepCreator with the name "Keystore Certificate Create" and the following properties
      | name        | type             | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | keystoreId  | java.lang.String | SSLKeystore                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | alias       | java.lang.String | qaCertificate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | certificate | java.lang.String | -----BEGIN CERTIFICATE-----\nMIIFVzCCBD+gAwIBAgISA38CzQctm3+HkSyZPnDL8TFsMA0GCSqGSIb3DQEBCwUA\nMEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD\nExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xOTA3MTkxMDIxMTdaFw0x\nOTEwMTcxMDIxMTdaMBsxGTAXBgNVBAMTEG1xdHQuZWNsaXBzZS5vcmcwggEiMA0G\nCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQnt6ZBEZ/vDG0JLqVB45lO6xlLazt\nYpEqZlGBket6PtjUGLdE2XivTpjtUkERS1cvPBqT1DH/yEZ1CU7iT/gfZtZotR0c\nqEMogSGkmrN1sAV6Eb+xGT3sPm1WFeKZqKdzAScdULoweUgwbNXa9kAB1uaSYBTe\ncq2ynfxBKWL/7bVtoeXUOyyaiIxVPTYz5XgpjSUB+9ML/v/+084XhIKA/avGPOSi\nRHOB+BsqTGyGhDgAHF+CDrRt8U1preS9AKXUvZ0aQL+djV8Y5nXPQPR8c2wplMwL\n5W/YMrM/dBm64vclKQLVPyEPqMOLMqcf+LkfQi6WOH+JByJfywAlme6jAgMBAAGj\nggJkMIICYDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsG\nAQUFBwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFHc+PmokFlx8Fh/0Lob125ef\nfLNyMB8GA1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyhMG8GCCsGAQUFBwEB\nBGMwYTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgzLmxldHNlbmNyeXB0\nLm9yZzAvBggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgzLmxldHNlbmNyeXB0\nLm9yZy8wGwYDVR0RBBQwEoIQbXF0dC5lY2xpcHNlLm9yZzBMBgNVHSAERTBDMAgG\nBmeBDAECATA3BgsrBgEEAYLfEwEBATAoMCYGCCsGAQUFBwIBFhpodHRwOi8vY3Bz\nLmxldHNlbmNyeXB0Lm9yZzCCAQMGCisGAQQB1nkCBAIEgfQEgfEA7wB2AHR+2oMx\nrTMQkSGcziVPQnDCv/1eQiAIxjc1eeYQe8xWAAABbAn2/p8AAAQDAEcwRQIhAIBl\nIZC2ZCMDs7bkBQN79xNO84VFpe7bQcMeaqHsQH9jAiAYV5kdZBgl17M5RB44NQ+y\nY/WOF1PWOrNrP3XdeEo7HAB1ACk8UZZUyDlluqpQ/FgH1Ldvv1h6KXLcpMMM9OVF\nR/R4AAABbAn2/o4AAAQDAEYwRAIgNYxfY0bjRfjhXjjAgyPRSLKq4O5tWTd2W4mn\nCpE3aCYCIGeKPyuuo9tvHbyVKF4bsoN76FmnOkdsYE0MCKeKkUOkMA0GCSqGSIb3\nDQEBCwUAA4IBAQCB0ykl1N2U2BMhzFo6dwrECBSFO+ePV2UYGrb+nFunWE4MMKBb\ndyu7dj3cYRAFCM9A3y0H967IcY+h0u9FgZibmNs+y/959wcbr8F1kvgpVKDb1FGs\ncuEArADQd3X+4TMM+IeIlqbGVXv3mYPrsP78LmUXkS7ufhMXsD5GSbSc2Zp4/v0o\n3bsJz6qwzixhqg30tf6siOs9yrpHpPnDnbRrahbwnYTpm6JP0lK53GeFec4ckNi3\nzT5+hEVOZ4JYPb3xVXkzIjSWmnDVbwC9MFtRaER9MhugKmiAp8SRLbylD0GKOhSB\n2BDf6JrzhIddKxQ75KgMZE6FQaC3Bz1DFyrj\n-----END CERTIFICATE----- |
      | timeout     | java.lang.Long   | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    And I query for the job with the name "TestJob - Keystore Steps" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And KuraMock is disconnected
    And I logout

  Scenario: Running a Job with Keystore Keypair Create Step Definition

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 1 event within 30 seconds
    And The type of the last event is "BIRTH"
    Given I create a job with the name "TestJob - Keystore Steps"
    And I create a new job target item
    And Search for step definition with the name "Keystore Keypair Create"
    And I prepare a JobStepCreator with the name "Keystore Keypair Create" and the following properties
      | name               | type              | value                                              |
      | keystoreId         | java.lang.String  | SSLKeystore                                        |
      | alias              | java.lang.String  | qaKeypair                                          |
      | size               | java.lang.Integer | 4096                                               |
      | algorithm          | java.lang.String  | RSA                                                |
      | signatureAlgorithm | java.lang.String  | SHA256withRSA                                      |
      | attributes         | java.lang.String  | CN=Let's Encrypt Authority X3,O=Let's Encrypt,C=US |
      | timeout            | java.lang.Long    | 10000                                              |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    And I confirm job target has step index 0 and status "PROCESS_OK" within 31 seconds
    And I query for the job with the name "TestJob - Keystore Steps" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for events from device "rpione3" in account "kapua-sys" I find 2 events within 30 seconds
    And KuraMock is disconnected
    And I logout

  Scenario: Running a Job with Keystore Item Delete Step Definition
  Multi-step job with a Keystore Certificate Install and Ketstore Keypair Create and then
  the deletion of those two new added Keystore Items

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    When Device is connected within 10 seconds
    Then Device status is "CONNECTED" within 10 seconds
    And I select account "kapua-sys"
    And I get the KuraMock device after 5 seconds
    When I search for events from device "rpione3" in account "kapua-sys" I find 1 event within 30 seconds
    And The type of the last event is "BIRTH"
    Given I create a job with the name "TestJob - Keystore Steps"
    And I create a new job target item
    And Search for step definition with the name "Keystore Certificate Create"
    And I prepare a JobStepCreator with the name "Keystore Certificate Create" and the following properties
      | name        | type             | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | keystoreId  | java.lang.String | SSLKeystore                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | alias       | java.lang.String | qaCertificate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | certificate | java.lang.String | -----BEGIN CERTIFICATE-----\nMIIFVzCCBD+gAwIBAgISA38CzQctm3+HkSyZPnDL8TFsMA0GCSqGSIb3DQEBCwUA\nMEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD\nExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xOTA3MTkxMDIxMTdaFw0x\nOTEwMTcxMDIxMTdaMBsxGTAXBgNVBAMTEG1xdHQuZWNsaXBzZS5vcmcwggEiMA0G\nCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQnt6ZBEZ/vDG0JLqVB45lO6xlLazt\nYpEqZlGBket6PtjUGLdE2XivTpjtUkERS1cvPBqT1DH/yEZ1CU7iT/gfZtZotR0c\nqEMogSGkmrN1sAV6Eb+xGT3sPm1WFeKZqKdzAScdULoweUgwbNXa9kAB1uaSYBTe\ncq2ynfxBKWL/7bVtoeXUOyyaiIxVPTYz5XgpjSUB+9ML/v/+084XhIKA/avGPOSi\nRHOB+BsqTGyGhDgAHF+CDrRt8U1preS9AKXUvZ0aQL+djV8Y5nXPQPR8c2wplMwL\n5W/YMrM/dBm64vclKQLVPyEPqMOLMqcf+LkfQi6WOH+JByJfywAlme6jAgMBAAGj\nggJkMIICYDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsG\nAQUFBwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFHc+PmokFlx8Fh/0Lob125ef\nfLNyMB8GA1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyhMG8GCCsGAQUFBwEB\nBGMwYTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgzLmxldHNlbmNyeXB0\nLm9yZzAvBggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgzLmxldHNlbmNyeXB0\nLm9yZy8wGwYDVR0RBBQwEoIQbXF0dC5lY2xpcHNlLm9yZzBMBgNVHSAERTBDMAgG\nBmeBDAECATA3BgsrBgEEAYLfEwEBATAoMCYGCCsGAQUFBwIBFhpodHRwOi8vY3Bz\nLmxldHNlbmNyeXB0Lm9yZzCCAQMGCisGAQQB1nkCBAIEgfQEgfEA7wB2AHR+2oMx\nrTMQkSGcziVPQnDCv/1eQiAIxjc1eeYQe8xWAAABbAn2/p8AAAQDAEcwRQIhAIBl\nIZC2ZCMDs7bkBQN79xNO84VFpe7bQcMeaqHsQH9jAiAYV5kdZBgl17M5RB44NQ+y\nY/WOF1PWOrNrP3XdeEo7HAB1ACk8UZZUyDlluqpQ/FgH1Ldvv1h6KXLcpMMM9OVF\nR/R4AAABbAn2/o4AAAQDAEYwRAIgNYxfY0bjRfjhXjjAgyPRSLKq4O5tWTd2W4mn\nCpE3aCYCIGeKPyuuo9tvHbyVKF4bsoN76FmnOkdsYE0MCKeKkUOkMA0GCSqGSIb3\nDQEBCwUAA4IBAQCB0ykl1N2U2BMhzFo6dwrECBSFO+ePV2UYGrb+nFunWE4MMKBb\ndyu7dj3cYRAFCM9A3y0H967IcY+h0u9FgZibmNs+y/959wcbr8F1kvgpVKDb1FGs\ncuEArADQd3X+4TMM+IeIlqbGVXv3mYPrsP78LmUXkS7ufhMXsD5GSbSc2Zp4/v0o\n3bsJz6qwzixhqg30tf6siOs9yrpHpPnDnbRrahbwnYTpm6JP0lK53GeFec4ckNi3\nzT5+hEVOZ4JYPb3xVXkzIjSWmnDVbwC9MFtRaER9MhugKmiAp8SRLbylD0GKOhSB\n2BDf6JrzhIddKxQ75KgMZE6FQaC3Bz1DFyrj\n-----END CERTIFICATE----- |
      | timeout     | java.lang.Long   | 10000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And Search for step definition with the name "Keystore Keypair Create"
    And I prepare a JobStepCreator with the name "Keystore Keypair Create" and the following properties
      | name               | type              | value                                              |
      | keystoreId         | java.lang.String  | SSLKeystore                                        |
      | alias              | java.lang.String  | qaKeypair                                          |
      | size               | java.lang.Integer | 4096                                               |
      | algorithm          | java.lang.String  | RSA                                                |
      | signatureAlgorithm | java.lang.String  | SHA256withRSA                                      |
      | attributes         | java.lang.String  | CN=Let's Encrypt Authority X3,O=Let's Encrypt,C=US |
      | timeout            | java.lang.Long    | 10000                                              |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And Search for step definition with the name "Keystore Item Delete"
    And I prepare a JobStepCreator with the name "Keystore Keypair Delete Keypair" and the following properties
      | name       | type             | value       |
      | keystoreId | java.lang.String | SSLKeystore |
      | alias      | java.lang.String | qaKeypair   |
      | timeout    | java.lang.Long   | 10000       |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And Search for step definition with the name "Keystore Item Delete"
    And I prepare a JobStepCreator with the name "Keystore Keypair Delete Certificate" and the following properties
      | name       | type             | value         |
      | keystoreId | java.lang.String | SSLKeystore   |
      | alias      | java.lang.String | qaCertificate |
      | timeout    | java.lang.Long   | 10000         |
    When I create a new JobStep from the existing creator
    Then No exception was thrown
    And I start a job
    And I confirm job target has step index 3 and status "PROCESS_OK" within 31 seconds
    And I query for the job with the name "TestJob - Keystore Steps" and I count 1 execution item and I confirm the executed job is finished within 20 seconds
    And I search for events from device "rpione3" in account "kapua-sys" I find 5 events within 30 seconds
    And KuraMock is disconnected
    And I logout

  @teardown
  Scenario: Tear down test resources
    Given Stop Docker environment
    And Clean Locator Instance