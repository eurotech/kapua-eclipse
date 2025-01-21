/*******************************************************************************
 * Copyright (c) 2020, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.datastore.internal;

import javax.inject.Singleton;

import org.eclipse.kapua.service.datastore.ClientInfoFactory;
import org.eclipse.kapua.service.datastore.internal.model.ClientInfoImpl;
import org.eclipse.kapua.service.datastore.model.ClientInfo;

/**
 * {@link ClientInfoFactory} implementation.
 *
 * @since 1.3.0
 */
@Singleton
public class ClientInfoFactoryImpl implements ClientInfoFactory {

    @Override
    public ClientInfo newStorable() {
        return new ClientInfoImpl();
    }

}
