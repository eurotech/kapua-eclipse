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
package org.eclipse.kapua.service.job.step.definition.internal;

import com.google.inject.Provides;
import org.eclipse.kapua.commons.core.AbstractKapuaModule;
import org.eclipse.kapua.commons.jpa.KapuaJpaRepositoryConfiguration;
import org.eclipse.kapua.service.authorization.AuthorizationService;
import org.eclipse.kapua.service.authorization.permission.PermissionFactory;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionFactory;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionRepository;
import org.eclipse.kapua.service.job.step.definition.JobStepDefinitionService;
import org.eclipse.kapua.storage.TxManager;

import javax.inject.Inject;
import javax.inject.Named;

public class JobStepDefinitionModule extends AbstractKapuaModule {
    @Override
    protected void configureModule() {
        bind(JobStepDefinitionFactory.class).to(JobStepDefinitionFactoryImpl.class);

        // The bind of the JobStepDefinitionAligner has been moved to JobEngineModule
        // bind(JobStepDefinitionAligner.class).in(Singleton.class);
    }

    @Provides
    @Inject
    JobStepDefinitionService jobStepDefinitionService(
            AuthorizationService authorizationService,
            PermissionFactory permissionFactory,
            @Named("jobTxManager") TxManager txManager,
            JobStepDefinitionRepository repository) {
        return new JobStepDefinitionServiceImpl(
                authorizationService,
                permissionFactory,
                txManager,
                repository
        );
    }

    @Provides
    @Inject
    JobStepDefinitionRepository jobStepDefinitionRepository(KapuaJpaRepositoryConfiguration jpaRepoConfig) {
        return new JobStepDefinitionImplJpaRepository(jpaRepoConfig);
    }

}
