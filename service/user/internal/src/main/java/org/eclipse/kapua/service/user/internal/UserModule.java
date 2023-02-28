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
package org.eclipse.kapua.service.user.internal;

import com.google.inject.Provides;
import org.eclipse.kapua.commons.configuration.AbstractKapuaConfigurableServiceCache;
import org.eclipse.kapua.commons.configuration.AccountChildrenFinder;
import org.eclipse.kapua.commons.configuration.CachingServiceConfigTransactedRepository;
import org.eclipse.kapua.commons.configuration.ResourceLimitedServiceConfigurationManagerImpl;
import org.eclipse.kapua.commons.configuration.RootUserTester;
import org.eclipse.kapua.commons.configuration.RootUserTesterImpl;
import org.eclipse.kapua.commons.configuration.ServiceConfigImplJpaTransactedRepository;
import org.eclipse.kapua.commons.configuration.ServiceConfigurationManager;
import org.eclipse.kapua.commons.configuration.ServiceConfigurationManagerCachingWrapper;
import org.eclipse.kapua.commons.configuration.UsedEntitiesCounterImpl;
import org.eclipse.kapua.commons.core.AbstractKapuaModule;
import org.eclipse.kapua.commons.jpa.AbstractEntityManagerFactory;
import org.eclipse.kapua.commons.jpa.EntityManagerSession;
import org.eclipse.kapua.commons.service.internal.cache.NamedEntityCache;
import org.eclipse.kapua.service.authorization.AuthorizationService;
import org.eclipse.kapua.service.authorization.permission.PermissionFactory;
import org.eclipse.kapua.service.user.UserDomains;
import org.eclipse.kapua.service.user.UserFactory;
import org.eclipse.kapua.service.user.UserNamedEntityService;
import org.eclipse.kapua.service.user.UserTransactedRepository;
import org.eclipse.kapua.service.user.UserService;

import javax.inject.Named;
import javax.inject.Singleton;

public class UserModule extends AbstractKapuaModule {
    @Override
    protected void configureModule() {
        bind(RootUserTester.class).to(RootUserTesterImpl.class);
        bind(UserNamedEntityService.class).to(UserNamedEntityServiceImpl.class);
        bind(UserFactory.class).to(UserFactoryImpl.class);
        bind(UserService.class).to(UserServiceImpl.class);
        bind(UserEntityManagerFactory.class).toInstance(new UserEntityManagerFactory());
        bind(UserCacheFactory.class).toInstance(new UserCacheFactory());
    }

    @Provides
    @Singleton
    @Named("UserServiceConfigurationManager")
    ServiceConfigurationManager userServiceConfigurationManager(
            UserEntityManagerFactory userEntityManagerFactory,
            UserFactory userFactory,
            PermissionFactory permissionFactory,
            AuthorizationService authorizationService,
            RootUserTester rootUserTester,
            AccountChildrenFinder accountChildrenFinder,
            UserTransactedRepository userRepository
    ) {
        return new ServiceConfigurationManagerCachingWrapper(
                new ResourceLimitedServiceConfigurationManagerImpl(UserService.class.getName(),
                        UserDomains.USER_DOMAIN,
                        new CachingServiceConfigTransactedRepository(
                                new ServiceConfigImplJpaTransactedRepository(new EntityManagerSession(userEntityManagerFactory)),
                                new AbstractKapuaConfigurableServiceCache().createCache()
                        ),
                        permissionFactory,
                        authorizationService,
                        rootUserTester,
                        accountChildrenFinder,
                        new UsedEntitiesCounterImpl(
                                userFactory,
                                UserDomains.USER_DOMAIN,
                                userRepository,
                                authorizationService,
                                permissionFactory)
                ));
    }

    @Provides
    @Singleton
    UserTransactedRepository userRepository(UserFactory userFactory) {
        return new CachingUserTransactedRepository(
                new UserImplJpaTransactedRepository(
                        () -> userFactory.newListResult(),
                        new EntityManagerSession(new AbstractEntityManagerFactory("kapua-user") {
                        })),
                (NamedEntityCache) new UserCacheFactory().createCache()
        );
    }
}
