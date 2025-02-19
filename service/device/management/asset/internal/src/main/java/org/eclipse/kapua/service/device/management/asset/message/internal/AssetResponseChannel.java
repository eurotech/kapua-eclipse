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
package org.eclipse.kapua.service.device.management.asset.message.internal;

import org.eclipse.kapua.service.device.management.asset.DeviceAsset;
import org.eclipse.kapua.service.device.management.asset.internal.DeviceAssetAppProperties;
import org.eclipse.kapua.service.device.management.message.response.KapuaResponseChannel;

/**
 * {@link DeviceAsset} {@link KapuaResponseChannel} implementation.
 *
 * @since 1.0.0
 */
public class AssetResponseChannel extends KapuaResponseChannel {

    private static final long serialVersionUID = 2129023762503450624L;

    /**
     * Constructor
     *
     * @since 1.5.0
     */
    public AssetResponseChannel() {
        setAppName(DeviceAssetAppProperties.APP_NAME);
        setVersion(DeviceAssetAppProperties.APP_VERSION);
    }
}
