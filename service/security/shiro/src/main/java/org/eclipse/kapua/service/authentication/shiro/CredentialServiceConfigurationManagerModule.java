/*******************************************************************************
 * Copyright (c) 2021, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.authentication.shiro;

import javax.inject.Singleton;

import org.eclipse.kapua.commons.configuration.CachingServiceConfigRepository;
import org.eclipse.kapua.commons.configuration.ResourceBasedServiceConfigurationMetadataProvider;
import org.eclipse.kapua.commons.configuration.RootUserTester;
import org.eclipse.kapua.commons.configuration.ServiceConfigImplJpaRepository;
import org.eclipse.kapua.commons.configuration.ServiceConfigurationManager;
import org.eclipse.kapua.commons.configuration.ServiceConfigurationManagerCachingWrapper;
import org.eclipse.kapua.commons.core.AbstractKapuaModule;
import org.eclipse.kapua.commons.jpa.EntityCacheFactory;
import org.eclipse.kapua.commons.jpa.KapuaJpaRepositoryConfiguration;
import org.eclipse.kapua.commons.jpa.KapuaJpaTxManagerFactory;
import org.eclipse.kapua.commons.util.xml.XmlUtil;
import org.eclipse.kapua.service.authentication.credential.CredentialService;
import org.eclipse.kapua.service.authentication.shiro.setting.KapuaAuthenticationSetting;

import com.google.inject.Module;
import com.google.inject.multibindings.ClassMapKey;
import com.google.inject.multibindings.ProvidesIntoMap;

/**
 * This module provides the ServiceConfigurationManager for the CredentialService.
 * <br><br>
 * Unfortunately Guice does not support overriding for Map binder entries, therefore if you need to change the behaviour of this ServiceConfigurationManager, just skip this module and define the new
 * instance in a separate one
 */
public class CredentialServiceConfigurationManagerModule extends AbstractKapuaModule implements Module {

    @Override
    protected void configureModule() {
    }

    @ProvidesIntoMap
    @ClassMapKey(CredentialService.class)
    @Singleton
    public ServiceConfigurationManager credentialServiceConfigurationManager(
            KapuaJpaTxManagerFactory jpaTxManagerFactory,
            RootUserTester rootUserTester,
            SystemPasswordLengthProvider systemPasswordLengthProvider,
            KapuaJpaRepositoryConfiguration jpaRepoConfig,
            KapuaAuthenticationSetting kapuaAuthenticationSetting,
            EntityCacheFactory entityCacheFactory,
            XmlUtil xmlUtil) {
        return new ServiceConfigurationManagerCachingWrapper(
                new CredentialServiceConfigurationManagerImpl(
                        jpaTxManagerFactory.create("kapua-authentication"),
                        new CachingServiceConfigRepository(
                                new ServiceConfigImplJpaRepository(jpaRepoConfig),
                                entityCacheFactory.createCache("AbstractKapuaConfigurableServiceCacheId")
                        ),
                        systemPasswordLengthProvider,
                        rootUserTester,
                        kapuaAuthenticationSetting,
                        new ResourceBasedServiceConfigurationMetadataProvider(xmlUtil)));
    }
}
