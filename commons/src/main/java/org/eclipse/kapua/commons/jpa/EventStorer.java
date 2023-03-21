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
package org.eclipse.kapua.commons.jpa;

import org.eclipse.kapua.model.KapuaEntity;
import org.eclipse.kapua.storage.TxContext;

import java.util.Optional;
import java.util.function.BiConsumer;

public interface EventStorer extends BiConsumer<TxContext, Optional<? extends KapuaEntity>> {
    @Override
    void accept(TxContext tx, Optional<? extends KapuaEntity> kapuaEntity);

    void accept(TxContext tx, KapuaEntity kapuaEntity);
}