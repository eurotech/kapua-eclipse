/*******************************************************************************
 * Copyright (c) 2025, 2025 Eurotech and/or its affiliates and others
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Eurotech
 *******************************************************************************/
package org.eclipse.kapua.qa.integration.steps.utils;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttSecurityException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

import java.net.HttpURLConnection;

/**
 * Wrapper for {@link HttpURLConnection} that implements {@link AutoCloseable}
 *
 * @since 2.1.0
 */
public class TestReadinessMqttBrokerConnection implements AutoCloseable {

    private final String testReadinessAddress;
    private MqttClient testReadinessClient;

    /**
     * Constructor.
     *
     * @param testReadinessAddress The mqtt address to check for readiness
     * @since 2.1.0
     */
    public TestReadinessMqttBrokerConnection(String testReadinessAddress) {
        this.testReadinessAddress = testReadinessAddress;
    }

    /**
     * Checks that the HTTP returns the expected HTTP response code.
     *
     * @return {@code true} if expected code is returned, {@code false} otherwise
     * @throws MqttException
     * @since 2.1.0
     */
    public boolean isReady() throws MqttException {
        testReadinessClient = new MqttClient(testReadinessAddress, "test-readiness", new MemoryPersistence());

        // These username and password do not match any entry.
        // We need just to receive the "Not authorized to connect" from the broker on connection attempt
        MqttConnectOptions clientOpts = new MqttConnectOptions();
        clientOpts.setUserName("test-readiness-user"); // This user do
        clientOpts.setPassword("test-readiness-password".toCharArray());
        clientOpts.setConnectionTimeout(1);

        try {
            testReadinessClient.connect(clientOpts);
        }
        catch (MqttSecurityException mse) {
            // When the Message Broker is ready will accept connection attempts.
            // Since we are not providing valid username and password we are interested on
            // receiving a MqttSecurityException with the following message.
            if ("Not authorized to connect".equals(mse.getMessage())) {
                return true;
            }
        }

        return false;
    }

    /**
     * Invokes {@link HttpURLConnection#disconnect()} to clean up resources.
     *
     * @since 2.1.0
     */
    @Override
    public void close() throws MqttException {
        if (testReadinessClient != null) {
            testReadinessClient.close();
        }
    }
}
