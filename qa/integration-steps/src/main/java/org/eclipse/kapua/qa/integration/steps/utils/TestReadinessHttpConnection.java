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

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Wrapper for {@link HttpURLConnection} that implements {@link AutoCloseable}
 *
 * @since 2.1.0
 */
public class TestReadinessHttpConnection implements AutoCloseable {

    private final URL testReadinessURL;
    private HttpURLConnection testReadinessConnection;
    private final int readyResponseCode;

    /**
     * Constructor.
     *
     * @param testUrl The HTTP URL to check for readiness
     * @throws Exception
     * @since 2.1.0
     */
    public TestReadinessHttpConnection(String testUrl) throws Exception {
        this(testUrl, 200);
    }


    /**
     * Constructor.
     *
     * @param testUrl The HTTP URL to check for readiness
     * @param readyResponseCode Which HTTP response code consider valid for readiness
     * @throws IOException
     * @since 2.1.0
     */
    public TestReadinessHttpConnection(String testUrl, int readyResponseCode) throws IOException {
        this.testReadinessURL = new URL(testUrl);
        this.readyResponseCode = readyResponseCode;
    }

    /**
     * Checks that the HTTP returns the expected HTTP response code.
     *
     * @return {@code true} if expected code is returned, {@code false} otherwise
     * @throws IOException
     * @since 2.1.0
     */
    public boolean isReady() throws IOException {
        testReadinessConnection = (HttpURLConnection) testReadinessURL.openConnection();
        testReadinessConnection.setConnectTimeout(5000);
        testReadinessConnection.setReadTimeout(5000);
        testReadinessConnection.setRequestMethod("GET");

        return testReadinessConnection.getResponseCode() == readyResponseCode;
    }

    /**
     * Invokes {@link HttpURLConnection#disconnect()} to clean up resources.
     *
     * @since 2.1.0
     */
    @Override
    public void close() {
        if (testReadinessConnection != null) {
            testReadinessConnection.disconnect();
        }
    }
}
