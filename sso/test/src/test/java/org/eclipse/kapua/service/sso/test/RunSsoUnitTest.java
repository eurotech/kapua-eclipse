/*******************************************************************************
 * Copyright (c) 2019 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.service.sso.test;

import cucumber.api.CucumberOptions;
import org.eclipse.kapua.qa.common.cucumber.CucumberProperty;
import org.junit.runner.RunWith;

@RunWith(CucumberWithPropertiesForSso.class)
@CucumberOptions(
        features = {
                "classpath:features/SsoService.feature"
        },
        glue = {
                "org.eclipse.kapua.qa.common",
                "org.eclipse.kapua.service.sso.steps",
                "org.eclipse.kapua.qa.integration.steps"
        },
        plugin = {
                "pretty",
                "html:target/SsoUnitTests",
                "json:target/SsoUnitTests_cucumber.json"
        },
        strict = true,
        monochrome = true)
@CucumberProperty(key="locator.class.impl", value="org.eclipse.kapua.qa.common.MockedLocator")
@CucumberProperty(key="test.type", value="unit")
@CucumberProperty(key="commons.db.schema", value="kapuadb")
@CucumberProperty(key="commons.db.schema.update", value="true")
public class RunSsoUnitTest {
}
