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
package org.eclipse.kapua.commons.cache;

public class CacheConfig {

    public final int maxSize;
    public final ExpiryPolicy expirationStrategy;
    public final int expirationTimeoutSeconds;

    public CacheConfig(int maxSize, int expirationTimeoutSeconds, ExpiryPolicy expirationStrategy) {
        this.expirationStrategy = expirationStrategy;
        this.expirationTimeoutSeconds = expirationTimeoutSeconds;
        this.maxSize = maxSize;
    }

}
