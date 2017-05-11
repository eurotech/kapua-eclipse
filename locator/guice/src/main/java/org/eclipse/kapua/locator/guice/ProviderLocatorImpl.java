/*******************************************************************************
 * Copyright (c) 2011, 2017 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.locator.guice;

import java.io.IOException;
import java.lang.annotation.Annotation;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.eclipse.kapua.KapuaErrorCodes;
import org.eclipse.kapua.KapuaRuntimeException;
import org.eclipse.kapua.commons.core.ApplicationPlugin;
import org.eclipse.kapua.commons.core.ProviderLocator;
import org.eclipse.kapua.commons.core.LifecycleHandler;
import org.eclipse.kapua.commons.util.ResourceUtils;
import org.eclipse.kapua.locator.KapuaLocatorException;
import org.eclipse.kapua.locator.KapuaProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.inject.Binding;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Key;


public class ProviderLocatorImpl extends ProviderLocator {

    private static final Logger logger = LoggerFactory.getLogger(ProviderLocatorImpl.class);

    private static final String INJECTOR_NAME = "parentInjector";
    private static final String SERVICE_RESOURCE = "locator.xml";
    
    public ProviderLocatorImpl() {
        
        URL locatorConfigURL = null;
        try {
            // Find locator configuration file
            List<URL> locatorConfigurations = Arrays.asList(ResourceUtils.getResource(SERVICE_RESOURCE));
            if (locatorConfigurations.isEmpty()) {
                return;
            }
    
            // Read configurations from resource files
            locatorConfigURL = locatorConfigurations.get(0);
            LocatorConfig locatorConfig;
                locatorConfig = LocatorConfig.fromURL(locatorConfigURL);
            
            Injector injector = Guice.createInjector(new ProviderModule(locatorConfig));
            InjectorRegistry.add(INJECTOR_NAME, injector);
            logger.info("Created injector {}", INJECTOR_NAME);
            
            Set<Class<?>> pluginsInfo;
            pluginsInfo = locatorConfig.getPluginsInfo();
            
            for (Class<?> clazz : pluginsInfo) {
                if (ApplicationPlugin.class.isAssignableFrom(clazz)) {
                    injector.getInstance(clazz);
                    logger.info("Initilize Kapua plugin {}", clazz);
                }
            }
        } catch (KapuaLocatorException e) {
            throw new KapuaRuntimeException(KapuaErrorCodes.INTERNAL_ERROR, e, "Cannot load " + locatorConfigURL);
        } catch (ClassNotFoundException e) {
            throw new KapuaRuntimeException(KapuaErrorCodes.INTERNAL_ERROR, e, "Cannot load " + locatorConfigURL);
        } catch (IOException e) {
            throw new KapuaRuntimeException(KapuaErrorCodes.INTERNAL_ERROR, e, "Cannot load " + locatorConfigURL);
        }
    }

    @Override
    public LifecycleHandler getLifecycleHandler() {
        Injector injector = InjectorRegistry.get(INJECTOR_NAME);
        return injector.getInstance(LifecycleHandler.class);
    }
   
    @Override
    public <T> T getProvider(Class<T> superOrImplClass) {
        
        Injector injector = InjectorRegistry.get(INJECTOR_NAME);
        
        Binding<T> binding = injector.getExistingBinding(Key.get(superOrImplClass));
        if (binding == null) {
            throw new RuntimeException(superOrImplClass.getName() + " has no binding.");
        }
        
        T t = injector.getInstance(superOrImplClass);
        Annotation providerAnnotation = t.getClass().getAnnotation(KapuaProvider.class);
        if (providerAnnotation != null) {
            return injector.getInstance(superOrImplClass);
        }
        
        throw new RuntimeException(t.getClass().getName() + " is not a provider.");
    }
    
    @Override
    public <T> List<Class<T>> getProviders(Class<T> superOrImplClasss) {
        
        Injector injector = InjectorRegistry.get(INJECTOR_NAME);

        ArrayList<Class<T>> providers = new ArrayList<Class<T>>();
        Map<Key<?>, Binding<?>> explicitBindings = injector.getBindings();
        for (Key<?> k:explicitBindings.keySet()) {
            Class<?> c = k.getTypeLiteral().getRawType();
            if (superOrImplClasss.isAssignableFrom(c)){
                providers.add((Class<T>) c);
            }
        }
        
        return providers;
    }
}
