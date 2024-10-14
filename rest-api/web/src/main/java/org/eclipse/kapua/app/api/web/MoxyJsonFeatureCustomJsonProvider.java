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

import org.glassfish.jersey.CommonProperties;
import org.glassfish.jersey.internal.InternalProperties;
import org.glassfish.jersey.internal.util.PropertiesHelper;
import org.glassfish.jersey.message.filtering.EntityFilteringFeature;
import org.glassfish.jersey.moxy.internal.MoxyFilteringFeature;
import org.glassfish.jersey.moxy.json.internal.FilteringMoxyJsonProvider;

import javax.ws.rs.Priorities;
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
    //Basically this is the org.glassfish.jersey.moxy.json.MoxyJsonFeature but with some tweaks to set a custom JsonProvider
    //NB: I already tried to extend that class but this leads to a bad behaviour since it will register a jsonProvider that interferes with the CustomMoxyJsonProvider here set

    private static final String JSON_FEATURE = MoxyJsonFeatureCustomJsonProvider.class.getSimpleName();

    @Override
    public boolean configure(final FeatureContext context) {
        //STARTING FROM THERE THE CODE HAS BEEN COPIED BY org.glassfish.jersey.moxy.json.MoxyJsonFeature
        final Configuration config = context.getConfiguration();

        if (CommonProperties.getValue(config.getProperties(), config.getRuntimeType(),
                CommonProperties.MOXY_JSON_FEATURE_DISABLE, Boolean.FALSE, Boolean.class)) {
            return false;
        }

        final String jsonFeature = CommonProperties.getValue(config.getProperties(), config.getRuntimeType(),
                InternalProperties.JSON_FEATURE, JSON_FEATURE, String.class);
        // Other JSON providers registered.
        if (!JSON_FEATURE.equalsIgnoreCase(jsonFeature)) {
            return false;
        }

        // Disable other JSON providers.
        context.property(PropertiesHelper.getPropertyNameForRuntime(InternalProperties.JSON_FEATURE, config.getRuntimeType()),
                JSON_FEATURE);

        // Set a slightly lower priority of workers than JSON-P so MOXy is not pick-ed up for JsonStructures (if both are used).
        final int workerPriority = Priorities.USER + 2000;

        if (EntityFilteringFeature.enabled(config)) {
            context.register(MoxyFilteringFeature.class);
            context.register(FilteringMoxyJsonProvider.class, workerPriority);
        } else {
            //THIS NEXT LINE IS DIFFERENT FROM org.glassfish.jersey.moxy.json.MoxyJsonFeature AND CUSTOMIZED FOR THE PURPOSE OF THIS CLASS
            context.register(CustomMoxyJsonProvider.class, workerPriority);
        }

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
