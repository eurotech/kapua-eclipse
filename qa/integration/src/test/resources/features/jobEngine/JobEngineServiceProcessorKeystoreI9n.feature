###############################################################################
# Copyright (c) 2024, 2024 Eurotech and/or its affiliates and others
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
@jobEngineTargetProcessors

Feature: Job Engine Service - Keystore Step Processors
  Tests for Device Management Keystore Processor

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

  Scenario: Keystore Certificate Create

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device birth message is sent
    And Device "rpione3" is connected within 10s
    And I create a job with the name "TestJob"
    And I add device targets to job
      | rpione3 |
    And I search for step definition with the name
      | Keystore Certificate Create |
    And I add job step to job with name "Test Step - Keystore Certificate Create" and with selected job step definition and properties
      | name        | type             | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | keystoreId  | java.lang.String | SSLKeystore                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | alias       | java.lang.String | qaCertificate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | certificate | java.lang.String | -----BEGIN CERTIFICATE-----\nMIIFVzCCBD+gAwIBAgISA38CzQctm3+HkSyZPnDL8TFsMA0GCSqGSIb3DQEBCwUA\nMEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD\nExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xOTA3MTkxMDIxMTdaFw0x\nOTEwMTcxMDIxMTdaMBsxGTAXBgNVBAMTEG1xdHQuZWNsaXBzZS5vcmcwggEiMA0G\nCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQnt6ZBEZ/vDG0JLqVB45lO6xlLazt\nYpEqZlGBket6PtjUGLdE2XivTpjtUkERS1cvPBqT1DH/yEZ1CU7iT/gfZtZotR0c\nqEMogSGkmrN1sAV6Eb+xGT3sPm1WFeKZqKdzAScdULoweUgwbNXa9kAB1uaSYBTe\ncq2ynfxBKWL/7bVtoeXUOyyaiIxVPTYz5XgpjSUB+9ML/v/+084XhIKA/avGPOSi\nRHOB+BsqTGyGhDgAHF+CDrRt8U1preS9AKXUvZ0aQL+djV8Y5nXPQPR8c2wplMwL\n5W/YMrM/dBm64vclKQLVPyEPqMOLMqcf+LkfQi6WOH+JByJfywAlme6jAgMBAAGj\nggJkMIICYDAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsG\nAQUFBwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFHc+PmokFlx8Fh/0Lob125ef\nfLNyMB8GA1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyhMG8GCCsGAQUFBwEB\nBGMwYTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgzLmxldHNlbmNyeXB0\nLm9yZzAvBggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgzLmxldHNlbmNyeXB0\nLm9yZy8wGwYDVR0RBBQwEoIQbXF0dC5lY2xpcHNlLm9yZzBMBgNVHSAERTBDMAgG\nBmeBDAECATA3BgsrBgEEAYLfEwEBATAoMCYGCCsGAQUFBwIBFhpodHRwOi8vY3Bz\nLmxldHNlbmNyeXB0Lm9yZzCCAQMGCisGAQQB1nkCBAIEgfQEgfEA7wB2AHR+2oMx\nrTMQkSGcziVPQnDCv/1eQiAIxjc1eeYQe8xWAAABbAn2/p8AAAQDAEcwRQIhAIBl\nIZC2ZCMDs7bkBQN79xNO84VFpe7bQcMeaqHsQH9jAiAYV5kdZBgl17M5RB44NQ+y\nY/WOF1PWOrNrP3XdeEo7HAB1ACk8UZZUyDlluqpQ/FgH1Ldvv1h6KXLcpMMM9OVF\nR/R4AAABbAn2/o4AAAQDAEYwRAIgNYxfY0bjRfjhXjjAgyPRSLKq4O5tWTd2W4mn\nCpE3aCYCIGeKPyuuo9tvHbyVKF4bsoN76FmnOkdsYE0MCKeKkUOkMA0GCSqGSIb3\nDQEBCwUAA4IBAQCB0ykl1N2U2BMhzFo6dwrECBSFO+ePV2UYGrb+nFunWE4MMKBb\ndyu7dj3cYRAFCM9A3y0H967IcY+h0u9FgZibmNs+y/959wcbr8F1kvgpVKDb1FGs\ncuEArADQd3X+4TMM+IeIlqbGVXv3mYPrsP78LmUXkS7ufhMXsD5GSbSc2Zp4/v0o\n3bsJz6qwzixhqg30tf6siOs9yrpHpPnDnbRrahbwnYTpm6JP0lK53GeFec4ckNi3\nzT5+hEVOZ4JYPb3xVXkzIjSWmnDVbwC9MFtRaER9MhugKmiAp8SRLbylD0GKOhSB\n2BDf6JrzhIddKxQ75KgMZE6FQaC3Bz1DFyrj\n-----END CERTIFICATE----- |
      | timeout     | java.lang.Long   | 5000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
    When I start a job
    And I wait job to finish its execution up to 10s
    Then I confirm that job has 1 job execution
    And I confirm that job target in job has step index 0 and status "PROCESS_OK"
    # TODO: check that certificate has been installed when KuraMock gets refactored

  Scenario: Keystore Keypair Create Processor

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device birth message is sent
    And Device "rpione3" is connected within 10s
    And I create a job with the name "TestJob"
    And I add device targets to job
      | rpione3 |
    And I search for step definition with the name
      | Keystore Keypair Create |
    And I add job step to job with name "Test Step - Keystore Keypair Create" and with selected job step definition and properties
      | name               | type              | value                                              |
      | keystoreId         | java.lang.String  | SSLKeystore                                        |
      | alias              | java.lang.String  | qaKeypair                                          |
      | size               | java.lang.Integer | 4096                                               |
      | algorithm          | java.lang.String  | RSA                                                |
      | signatureAlgorithm | java.lang.String  | SHA256withRSA                                      |
      | attributes         | java.lang.String  | CN=Let's Encrypt Authority X3,O=Let's Encrypt,C=US |
      | timeout            | java.lang.Long    | 5000                                               |
    When I start a job
    And I wait job to finish its execution up to 10s
    Then I confirm that job has 1 job execution
    And I confirm that job target in job has step index 0 and status "PROCESS_OK"
    # TODO: check that keypair has been created when KuraMock gets refactored

  Scenario: Keystore Item Delete Processor

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I start the Kura Mock
    And Device birth message is sent
    And Device "rpione3" is connected within 10s
    And I create a job with the name "TestJob"
    And I add device targets to job
      | rpione3 |
    And I search for step definition with the name
      | Keystore Item Delete |
    And I add job step to job with name "Test Step - Keystore Item Delete" and with selected job step definition and properties
      | name       | type             | value         |
      | keystoreId | java.lang.String | SSLKeystore   |
      | alias      | java.lang.String | qaCertificate |
      | timeout    | java.lang.Long   | 5000          |
    When I start a job
    And I wait job to finish its execution up to 10s
    Then I confirm that job has 1 job execution
    And I confirm that job target in job has step index 0 and status "PROCESS_OK"
    # TODO: check that item has been deleted when KuraMock gets refactored

  @teardown
  Scenario: Tear down test resources
    Given I logout
    And KuraMock is disconnected
    And Stop Docker environment
    And Clean Locator Instance