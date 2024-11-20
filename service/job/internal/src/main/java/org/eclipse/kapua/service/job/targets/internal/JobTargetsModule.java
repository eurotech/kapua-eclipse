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
package org.eclipse.kapua.service.job.targets.internal;

import com.google.inject.Provides;
import org.eclipse.kapua.commons.core.AbstractKapuaModule;
import org.eclipse.kapua.commons.jpa.KapuaJpaRepositoryConfiguration;
import org.eclipse.kapua.service.authorization.AuthorizationService;
import org.eclipse.kapua.service.authorization.permission.PermissionFactory;
import org.eclipse.kapua.service.job.JobRepository;
import org.eclipse.kapua.service.job.targets.JobTargetFactory;
import org.eclipse.kapua.service.job.targets.JobTargetRepository;
import org.eclipse.kapua.service.job.targets.JobTargetService;
import org.eclipse.kapua.storage.TxManager;

import javax.inject.Named;
import javax.inject.Singleton;

public class JobTargetsModule extends AbstractKapuaModule {
    @Override
    protected void configureModule() {
        bind(JobTargetFactory.class).to(JobTargetFactoryImpl.class);
    }

    @Provides
    @Singleton
    JobTargetService jobTargetService(AuthorizationService authorizationService,
                                      PermissionFactory permissionFactory,
                                      @Named("jobTxManager") TxManager txManager,
                                      JobTargetRepository jobTargetRepository,
                                      JobTargetFactory jobTargetFactory,
                                      JobRepository jobRepository) {
        return new JobTargetServiceImpl(
                authorizationService,
                permissionFactory,
                txManager,
                jobTargetRepository,
                jobTargetFactory,
                jobRepository);
    }

    @Provides
    @Singleton
    JobTargetRepository jobTargetRepository(KapuaJpaRepositoryConfiguration jpaRepoConfig) {
        return new JobTargetImplJpaRepository(jpaRepoConfig);
    }
}
