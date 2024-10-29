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
package org.eclipse.kapua.service.authentication;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.env.BasicIniEnvironment;
import org.apache.shiro.env.Environment;
import org.apache.shiro.mgt.SecurityManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.ImportResource;
import org.springframework.context.annotation.PropertySource;

/**
 * Authentication application container main class
 */
@ImportResource({"classpath:spring/applicationContext.xml"})
@PropertySource(value = "classpath:spring/application.properties")
@Import(SpringBridge.class)
@SpringBootApplication
public class AuthenticationApplication {

    private static final Logger logger = LoggerFactory.getLogger(AuthenticationApplication.class);

    public AuthenticationApplication() {
        try {
            Environment env = new BasicIniEnvironment("classpath:shiro.ini");
            SecurityManager securityManager = env.getSecurityManager();
            SecurityUtils.setSecurityManager(securityManager);
        } catch (Exception e) {
            logger.error("Error loading Shiro configuration.", e);
            throw new SecurityException(e);
        }
    }

    public void doNothing() {
        //spring needs a public constructor but our checkstyle doesn't allow a class with only static methods and a public constructor
    }

    public static void main(String[] args) {
        //org.springframework.context.ApplicationContext is not needed now so don't keep the SpringApplication.run return
        System.setProperty("org.springframework.boot.logging.LoggingSystem", "none");
        SpringApplication.run(AuthenticationApplication.class, args);
    }

}
