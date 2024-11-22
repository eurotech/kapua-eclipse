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
package org.eclipse.kapua.app.api.core;

import org.glassfish.jersey.internal.InternalProperties;
import org.glassfish.jersey.internal.util.PropertiesHelper;
import javax.ws.rs.core.Configuration;
import javax.ws.rs.core.Feature;
import javax.ws.rs.core.FeatureContext;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.ext.Provider;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.bind.helpers.DefaultValidationEventHandler;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;

public class MoxyJsonFeatureCustomJsonProvider implements Feature {
    //A custom feature used to set a custom moxyJsonProvider

    private static final String JSON_FEATURE = MoxyJsonFeatureCustomJsonProvider.class.getSimpleName();

    @Override
    public boolean configure(final FeatureContext context) {
        final Configuration config = context.getConfiguration();
        // Disable other JSON providers. In this way the org.glassfish.jersey.moxy.json.MoxyJsonFeature (registered as default by MOXy) will skip the registration of the default provider
        context.property(PropertiesHelper.getPropertyNameForRuntime(InternalProperties.JSON_FEATURE, config.getRuntimeType()),
                JSON_FEATURE);
        context.register(CustomMoxyJsonProvider.class);
        return true;
    }

    @Provider
    public static class CustomMoxyJsonProvider extends org.glassfish.jersey.moxy.json.internal.ConfigurableMoxyJsonProvider {
        //A custom moxyJsonProvider that sets the unmarshaller validationEventHandler to the default one. This one allows to propagate exceptions to the stack when an error is found (for example, when an exception has been thrown from one of our custom "xmlAdapters")
        @Override
        protected void preReadFrom(Class<Object> type, Type genericType, Annotation[] annotations, MediaType mediaType, MultivaluedMap<String, String> httpHeaders, Unmarshaller unmarshaller) throws JAXBException {
            super.preReadFrom(type, genericType, annotations, mediaType, httpHeaders, unmarshaller);
            unmarshaller.setEventHandler(new DefaultValidationEventHandler());
        }
    }
}
