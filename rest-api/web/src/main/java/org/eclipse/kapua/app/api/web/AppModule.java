/*******************************************************************************
 * Copyright (c) 2016, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.app.api.web;

import javax.inject.Named;
import javax.inject.Singleton;

import org.eclipse.kapua.app.api.core.model.StorableEntityId;
import org.eclipse.kapua.app.api.core.model.device.management.JsonGenericRequestMessage;
import org.eclipse.kapua.app.api.core.model.device.management.JsonGenericResponseMessage;
import org.eclipse.kapua.app.api.core.settings.KapuaApiCoreSetting;
import org.eclipse.kapua.app.api.core.settings.KapuaApiCoreSettingKeys;
import org.eclipse.kapua.app.api.resources.v1.resources.model.device.management.keystore.DeviceKeystoreCertificateInfo;
import org.eclipse.kapua.commons.core.AbstractKapuaModule;
import org.eclipse.kapua.commons.core.JaxbClassProvider;
import org.eclipse.kapua.commons.core.SimpleJaxbClassProvider;
import org.eclipse.kapua.commons.liquibase.DatabaseCheckUpdate;
import org.eclipse.kapua.commons.util.xml.JAXBContextProvider;
import org.eclipse.kapua.commons.util.xml.JAXBContextProviderImpl;
import org.eclipse.kapua.commons.util.xml.XmlRootAnnotatedJaxbClassesScanner;
import org.eclipse.kapua.locator.LocatorConfig;

import com.google.inject.Provides;
import com.google.inject.multibindings.ProvidesIntoSet;
import org.eclipse.kapua.service.scheduler.trigger.definition.quartz.TriggerDefinitionAligner;

public class AppModule extends AbstractKapuaModule {

    @Override
    protected void configureModule() {
        bind(DatabaseCheckUpdate.class).in(Singleton.class);
        bind(KapuaApiCoreSetting.class).in(Singleton.class);

        bind(TriggerDefinitionAligner.class).in(Singleton.class);

        // Switching manually-configured JAXBContextProvider to autodiscovery one below
        // bind(JAXBContextProvider.class).to(RestApiJAXBContextProvider.class).in(Singleton.class);
        bind(JAXBContextProvider.class).to(JAXBContextProviderImpl.class).in(Singleton.class);
    }

    @ProvidesIntoSet
    JaxbClassProvider jaxbClassesAutoDiscoverer(LocatorConfig locatorConfig) {
        return new XmlRootAnnotatedJaxbClassesScanner(locatorConfig);
    }

    @ProvidesIntoSet
    JaxbClassProvider restApiCustomClassesForJaxb(LocatorConfig locatorConfig) {
        return new SimpleJaxbClassProvider(
                DeviceKeystoreCertificateInfo.class,
                JsonGenericRequestMessage.class,
                JsonGenericResponseMessage.class,
                StorableEntityId.class
        );
    }

    @Provides
    @Named("showStackTrace")
    Boolean showStackTrace(KapuaApiCoreSetting kapuaApiCoreSetting) {
        return kapuaApiCoreSetting.getBoolean(KapuaApiCoreSettingKeys.API_EXCEPTION_STACKTRACE_SHOW, false);
    }

    @Provides
    @Named("metricModuleName")
    String metricModuleName() {
        return "rest-api";
    }

    @Provides
    @Named("eventsModuleName")
    String eventModuleName() {
        return "rest_api";
    }

}
