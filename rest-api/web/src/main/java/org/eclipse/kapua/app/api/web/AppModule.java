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

import com.google.inject.Provides;
import org.eclipse.kapua.app.api.core.settings.KapuaApiCoreSetting;
import org.eclipse.kapua.app.api.core.settings.KapuaApiCoreSettingKeys;
import org.eclipse.kapua.commons.core.AbstractKapuaModule;
import org.eclipse.kapua.commons.liquibase.DatabaseCheckUpdate;
import org.eclipse.kapua.commons.util.xml.JAXBContextProvider;
import org.eclipse.kapua.commons.util.xml.XmlUtil;
import org.eclipse.kapua.service.scheduler.trigger.definition.quartz.TriggerDefinitionAligner;

import javax.inject.Named;
import javax.inject.Singleton;

public class AppModule extends AbstractKapuaModule {
    @Override
    protected void configureModule() {
        bind(DatabaseCheckUpdate.class).asEagerSingleton();
        bind(KapuaApiCoreSetting.class).in(Singleton.class);

        bind(TriggerDefinitionAligner.class).in(Singleton.class);
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

    @Provides
    @Singleton
    JAXBContextProvider jaxbContextProvider() {
        final JAXBContextProvider jaxbContextProvider = new RestApiJAXBContextProvider();
        XmlUtil.setContextProvider(jaxbContextProvider);
        return jaxbContextProvider;
    }
}
