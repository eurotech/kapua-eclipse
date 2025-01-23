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
#     Eurotech - initial API and implementation
###############################################################################
@connection
@userCoupling
@env_docker

Feature: User Coupling

@setup
  Scenario: Start docker environment
    Given Init Jaxb Context
    And Init Security Context
    And Start full docker environment

  Scenario: Test LOOSE user coupling on single connection

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name        | scopeId |
      | test-acc-1  | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"
    And Such a set of privileged users for account "test-acc-1"
      | name        | password        | displayName  | status  |
      | test-user-1 | KeepCalm123.    | Test User 1  | ENABLED |
      | test-user-2 | KeepCalm123.    | Test User 2  | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
    And The following device connections
      | scope       | clientId   | user        | userCouplingMode |
      | test-acc-1  | device-1   | test-user-1 | LOOSE            |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-2" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

  Scenario: New connection with reserved ID

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name        | scopeId |
      | test-acc-1  | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"
    And Such a set of privileged users for account "test-acc-1"
      | name        | password        | displayName  | status  |
      | test-user-1 | KeepCalm123.    | Test User 1  | ENABLED |
      | test-user-2 | KeepCalm123.    | Test User 2  | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
    And The following device connections
      | scope       | clientId   | user        | reservedUser |
      | test-acc-1  | device-1   | test-user-1 | test-user-1  |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 0 connections

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-2" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

  Scenario: Test STRICT user coupling on single connection

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name        | scopeId |
      | test-acc-1  | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"
    And Such a set of privileged users for account "test-acc-1"
      | name        | displayName  | status  |
      | test-user-1 | Test User 1  | ENABLED |
      | test-user-2 | Test User 2  | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
    And The following device connections
      | scope       | clientId   | user        | userCouplingMode |
      | test-acc-1  | device-1   | test-user-1 | STRICT           |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

  Scenario: Test STRICT user coupling with user change allowed on single connection

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name        | scopeId |
      | test-acc-1  | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"
    And Such a set of privileged users for account "test-acc-1"
      | name        | displayName  | status  |
      | test-user-1 | Test User 1  | ENABLED |
      | test-user-2 | Test User 2  | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
    And The following device connections
      | scope       | clientId   | user        | userCouplingMode |
      | test-acc-1  | device-1   | test-user-1 | STRICT           |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-1" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-2" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

  Scenario: Test LOOSE user coupling with 3 connections

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name        | scopeId |
      | test-acc-1  | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"
    And Such a set of privileged users for account "test-acc-1"
      | name        | displayName  | status  |
      | test-user-1 | Test User 1  | ENABLED |
      | test-user-2 | Test User 2  | ENABLED |
      | test-user-3 | Test User 3  | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
      | device-2 | testGateway | ReliaGate 10-20 | 12341234ABD  |
      | device-3 | testGateway | ReliaGate 10-20 | 12341234ABE  |
    And The following device connections
      | scope       | clientId   | user        | userCouplingMode |
      | test-acc-1  | device-1   | test-user-1 | LOOSE            |
      | test-acc-1  | device-2   | test-user-2 | LOOSE            |
      | test-acc-1  | device-3   | test-user-3 | LOOSE            |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

  Scenario: Test STRICT user coupling with 3 connections and a reserved user

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name       | scopeId |
      | test-acc-1 | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"
    And Such a set of privileged users for account "test-acc-1"
      | name        | displayName | status  |
      | test-user-1 | Test User 1 | ENABLED |
      | test-user-2 | Test User 2 | ENABLED |
      | test-user-3 | Test User 3 | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
      | device-2 | testGateway | ReliaGate 10-20 | 12341234ABD  |
      | device-3 | testGateway | ReliaGate 10-20 | 12341234ABE  |
    And The following device connections
      | scope      | clientId | user        | userCouplingMode | reservedUser |
      | test-acc-1 | device-1 | test-user-1 | STRICT           | test-user-1  |
      | test-acc-1 | device-2 | test-user-2 | LOOSE            |              |
      | test-acc-1 | device-3 | test-user-3 | LOOSE            |              |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

  Scenario: Extra long continuous test with multiple subscenarios with LOOSE default connection mode

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name        | scopeId |
      | test-acc-1  | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"
    And Such a set of privileged users for account "test-acc-1"
      | name        | displayName  | status  |
      | test-user-1 | Test User 1  | ENABLED |
      | test-user-2 | Test User 2  | ENABLED |
      | test-user-3 | Test User 3  | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
      | device-2 | testGateway | ReliaGate 10-20 | 12341234ABD  |
      | device-3 | testGateway | ReliaGate 10-20 | 12341234ABE  |
    And The following device connections
      | scope       | clientId   | user        |
      | test-acc-1  | device-1   | test-user-1 |
      | test-acc-1  | device-2   | test-user-2 |
      | test-acc-1  | device-3   | test-user-3 |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Then I set the user coupling mode for the connection from device "device-1" in account "test-acc-1" to "STRICT"
    And I set the reserved user for the connection from device "device-1" in account "test-acc-1" to "test-user-1"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    And I set the reserved user for the connection from device "device-1" in account "test-acc-1" to "null"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator

    And I set the reserved user for the connection from device "device-1" in account "test-acc-1" to "test-user-1"
    Then I set the user coupling mode for the connection from device "device-2" in account "test-acc-1" to "STRICT"
    # Try to set a duplicate reserved user
    Given I expect the exception "KapuaSQLIntegrityConstraintViolationException" with the text "Entity constraint violation error."
    When I set the reserved user for the connection from device "device-2" in account "test-acc-1" to "test-user-1"
    Then An exception was thrown
    # Reserved users must be unique!
    When I set the reserved user for the connection from device "device-2" in account "test-acc-1" to "test-user-2"
    Then No exception was thrown

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    When I set the reserved user for the connection from device "device-2" in account "test-acc-1" to "null"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Then I set the user change flag for the connection from device "device-2" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-2" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-2" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "CONNECTED"
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Then I set the user coupling mode for the connection from device "device-3" in account "test-acc-1" to "STRICT"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-3" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-3" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

  Scenario: Extra long continuous test with multiple subscenarios with STRICT default connection mode

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name       | scopeId |
      | test-acc-1 | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "STRICT"
    And Such a set of privileged users for account "test-acc-1"
      | name        | displayName | status  |
      | test-user-1 | Test User 1 | ENABLED |
      | test-user-2 | Test User 2 | ENABLED |
      | test-user-3 | Test User 3 | ENABLED |
    And Devices such as
      | clientId | displayName | modelId         | serialNumber |
      | device-1 | testGateway | ReliaGate 10-20 | 12341234ABC  |
      | device-2 | testGateway | ReliaGate 10-20 | 12341234ABD  |
      | device-3 | testGateway | ReliaGate 10-20 | 12341234ABE  |
    And The following device connections
      | scope      | clientId | user        |
      | test-acc-1 | device-1 | test-user-1 |
      | test-acc-1 | device-2 | test-user-2 |
      | test-acc-1 | device-3 | test-user-3 |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user coupling mode for the connection from device "device-1" in account "test-acc-1" to "STRICT"
    And I set the reserved user for the connection from device "device-1" in account "test-acc-1" to "test-user-1"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    And I set the reserved user for the connection from device "device-1" in account "test-acc-1" to "null"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator

    And I set the reserved user for the connection from device "device-1" in account "test-acc-1" to "test-user-1"
    Then I set the user coupling mode for the connection from device "device-2" in account "test-acc-1" to "STRICT"
# Try to set a duplicate reserved user
    Given I expect the exception "KapuaSQLIntegrityConstraintViolationException" with the text "Entity constraint violation error."
    When I set the reserved user for the connection from device "device-2" in account "test-acc-1" to "test-user-1"
    Then An exception was thrown
# Reserved users must be unique!
    When I set the reserved user for the connection from device "device-2" in account "test-acc-1" to "test-user-2"
    Then No exception was thrown

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    When I set the reserved user for the connection from device "device-2" in account "test-acc-1" to "null"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Then I set the user change flag for the connection from device "device-2" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-2" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-2" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Then I set the user change flag for the connection from device "device-3" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-3" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

  Scenario: Extra long continuous test with multiple subscenarios with STRICT default connection mode and no previously defined devices

    When I login as user with name "kapua-sys" and password "kapua-password"
    Given Account
      | name       | scopeId |
      | test-acc-1 | 1       |
    And A full set of device privileges for account "test-acc-1"
    And The default connection coupling mode for account "test-acc-1" is set to "STRICT"
    And Such a set of privileged users for account "test-acc-1"
      | name        | displayName | status  |
      | test-user-1 | Test User 1 | ENABLED |
      | test-user-2 | Test User 2 | ENABLED |
      | test-user-3 | Test User 3 | ENABLED |

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-2" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-2" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    When I set the reserved user for the connection from device "device-2" in account "test-acc-1" to "test-user-2"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-2" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-2" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-3" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-3" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    And The default connection coupling mode for account "test-acc-1" is set to "LOOSE"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-3" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-2" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-2"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-2" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-3" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-3" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-3"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-3" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-3" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    And The default connection coupling mode for account "test-acc-1" is set to "STRICT"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-3" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Then I set the user change flag for the connection from device "device-1" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-1:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-1" within 10 seconds
    Then I stop the simulator
    And I wait for 2 seconds

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-2:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I wait for 2 seconds
    When I search for a connection from the device "device-1" in account "test-acc-1"
    Then I find 1 connection
    And The connection status is "DISCONNECTED"

    Then I set the user change flag for the connection from device "device-1" in account "test-acc-1" to "true"

    Given The account name is "test-acc-1" and the client ID is "device-1"
    And The broker URI is "tcp://test-user-3:KeepCalm123.@localhost:1883"
    When I start the simulator
    And I search for a connection from the device "device-1" in account "test-acc-1" I find 1 connection with status "CONNECTED" and user "test-user-3" within 10 seconds
    Then I stop the simulator

@teardown
  Scenario: Stop docker environment
    Given Stop full docker environment
    And Clean Locator Instance
