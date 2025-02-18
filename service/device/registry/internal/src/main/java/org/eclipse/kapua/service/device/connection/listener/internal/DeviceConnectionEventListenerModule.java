/*******************************************************************************
 * Copyright (c) 2023, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.device.connection.listener.internal;

import javax.inject.Named;

import org.eclipse.kapua.commons.core.AbstractKapuaModule;
import org.eclipse.kapua.commons.core.ServiceModule;
import org.eclipse.kapua.commons.event.ServiceEventHouseKeeperFactoryImpl;
import org.eclipse.kapua.commons.service.event.store.api.EventStoreRecordRepository;
import org.eclipse.kapua.commons.service.event.store.internal.EventStoreServiceImpl;
import org.eclipse.kapua.event.ServiceEventBus;
import org.eclipse.kapua.event.ServiceEventBusException;
import org.eclipse.kapua.service.authorization.AuthorizationService;
import org.eclipse.kapua.service.device.connection.listener.DeviceConnectionEventListenerService;
import org.eclipse.kapua.service.device.registry.KapuaDeviceRegistrySettingKeys;
import org.eclipse.kapua.service.device.registry.KapuaDeviceRegistrySettings;
import org.eclipse.kapua.storage.TxManager;

import com.google.inject.Module;
import com.google.inject.multibindings.ProvidesIntoSet;

/**
 * {@code kapua-account-internal} {@link Module} implementation.
 *
 * @since 2.0.0
 */
public class DeviceConnectionEventListenerModule extends AbstractKapuaModule implements Module {

    @Override
    protected void configureModule() {
        bind(DeviceConnectionEventListenerService.class).to(DeviceConnectionEventListenerServiceImpl.class);
    }

    @ProvidesIntoSet
    protected ServiceModule deviceConnectionEventListenerServiceModule(DeviceConnectionEventListenerService deviceConnectionEventListenerService,
            AuthorizationService authorizationService,
            KapuaDeviceRegistrySettings kapuaDeviceRegistrySettings,
            @Named("DeviceRegistryTransactionManager") TxManager txManager,
            EventStoreRecordRepository eventStoreRecordRepository,
            ServiceEventBus serviceEventBus,
            @Named("eventsModuleName") String eventModuleName
    ) throws ServiceEventBusException {

        String address = kapuaDeviceRegistrySettings.getString(KapuaDeviceRegistrySettingKeys.DEVICE_EVENT_ADDRESS);
        return new DeviceConnectionEventListenerServiceModule(
                deviceConnectionEventListenerService,
                address,
                new ServiceEventHouseKeeperFactoryImpl(
                        new EventStoreServiceImpl(
                                authorizationService,
                                txManager,
                                eventStoreRecordRepository
                        ),
                        txManager,
                        serviceEventBus
                ),
                serviceEventBus,
                eventModuleName);
    }
}
