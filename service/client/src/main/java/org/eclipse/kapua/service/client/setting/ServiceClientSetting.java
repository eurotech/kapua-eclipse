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
package org.eclipse.kapua.service.client.setting;

import org.eclipse.kapua.commons.setting.AbstractKapuaSetting;

/**
 * Service client setting implementation.<br> This class handles settings for the {@link ServiceClientSettingKey}.
 */
public final class ServiceClientSetting extends AbstractKapuaSetting<ServiceClientSettingKey> {

    private static final String CONFIG_RESOURCE_NAME = "kapua-service-client-setting.properties";

    public ServiceClientSetting() {
        super(CONFIG_RESOURCE_NAME);
    }
}
