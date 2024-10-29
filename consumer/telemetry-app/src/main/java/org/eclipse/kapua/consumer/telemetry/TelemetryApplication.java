/*******************************************************************************
 * Copyright (c) 2020, 2022 Eurotech and/or its affiliates and others
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.consumer.telemetry;

import org.eclipse.kapua.service.security.SecurityUtil;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.ImportResource;
import org.springframework.context.annotation.PropertySource;

/**
 * Telemetry application container main class
 */
@ImportResource({ "classpath:spring/applicationContext.xml" })
@PropertySource(value = "classpath:spring/application.properties")
@Import(SpringBridge.class)
@SpringBootApplication
public class TelemetryApplication {

    public TelemetryApplication() {
        SecurityUtil.initSecurityManager();
    }

    public void doNothing() {
        //spring needs a public constructor but our checkstyle doesn't allow a class with only static methods and a public constructor
    }

    public static void main(String[] args) {
        //org.springframework.context.ApplicationContext is not needed now so don't keep the SpringApplication.run return
        System.setProperty("org.springframework.boot.logging.LoggingSystem", "none");
        SpringApplication.run(TelemetryApplication.class, args);
    }

}
