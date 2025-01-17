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
package org.eclipse.kapua.service.authorization.domain.shiro;

import javax.inject.Singleton;

import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.authorization.domain.Domain;
import org.eclipse.kapua.service.authorization.domain.DomainFactory;

/**
 * {@link DomainFactory} implementation.
 *
 * @since 1.0.0
 */
@Singleton
public class DomainFactoryImpl implements DomainFactory {

    @Override
    public Domain newEntity(KapuaId scopeId) {
        return new DomainImpl(scopeId);
    }

    @Override
    public Domain clone(Domain domain) {
        return new DomainImpl(domain);
    }
}
