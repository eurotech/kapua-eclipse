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
package org.eclipse.kapua.commons.jpa;

import org.eclipse.kapua.KapuaEntityNotFoundException;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.commons.event.ServiceEventScope;
import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.commons.service.event.store.api.EventStoreRecord;
import org.eclipse.kapua.commons.service.event.store.api.EventStoreRecordRepository;
import org.eclipse.kapua.commons.service.event.store.api.ServiceEventUtil;
import org.eclipse.kapua.event.ServiceEvent;
import org.eclipse.kapua.model.KapuaEntity;
import org.eclipse.kapua.storage.TxContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

public class EventStorerImpl implements EventStorer {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final EventStoreRecordRepository repository;

    public EventStorerImpl(EventStoreRecordRepository repository) {
        this.repository = repository;
    }

    @Override
    public void accept(TxContext tx, Optional<? extends KapuaEntity> maybeKapuaEntity) {
        if (!maybeKapuaEntity.isPresent()) {
            return;
        }
        doAccept(tx, maybeKapuaEntity.get());
    }

    @Override
    public void accept(TxContext tx, KapuaEntity kapuaEntity) {
        doAccept(tx, kapuaEntity);
    }

    void doAccept(TxContext tx, KapuaEntity kapuaEntity) {
        if (kapuaEntity instanceof EventStoreRecord) {
            return;
        }
        final ServiceEvent serviceEvent = ServiceEventScope.get();
        if (serviceEvent == null) {
            return;
        }

        if (kapuaEntity instanceof KapuaEntity) {
            //make sense to override the entity id and type without checking for previous empty values?
            //override only if parameters are not evaluated
            logger.info("Updating service event entity infos (type, id and scope id) if missing...");
            if (serviceEvent.getEntityType() == null || serviceEvent.getEntityType().trim().length() <= 0) {
                logger.info("Kapua event - update entity type to '{}'", kapuaEntity.getClass().getName());
                serviceEvent.setEntityType(kapuaEntity.getClass().getName());
            }
            if (serviceEvent.getEntityId() == null) {
                logger.info("Kapua event - update entity id to '{}'", kapuaEntity.getId());
                serviceEvent.setEntityId(kapuaEntity.getId());
            }
            if (serviceEvent.getEntityScopeId() == null) {
                logger.info("Kapua event - update entity scope id to '{}'", kapuaEntity.getScopeId());
                serviceEvent.setEntityScopeId(kapuaEntity.getScopeId());
            }
            logger.info("Updating service event entity infos (type, id and scope id) if missing... DONE");
            logger.info("Entity '{}' with id '{}' and scope id '{}' found!", kapuaEntity.getClass().getName(), kapuaEntity.getId(), kapuaEntity.getScopeId());
        }

        //insert the kapua event only if it's a new entity
        EventStoreRecord persistedKapuaEvent;
        try {
            if (isNewEvent(serviceEvent)) {
                persistedKapuaEvent = repository.create(tx, ServiceEventUtil.fromServiceEventBus(serviceEvent));
            } else {
                persistedKapuaEvent = repository.update(tx,
                        ServiceEventUtil.mergeToEntity(
                                repository.find(tx, serviceEvent.getScopeId(), KapuaEid.parseCompactId(serviceEvent.getId()))
                                        .orElseThrow(() -> new KapuaEntityNotFoundException(EventStoreRecord.TYPE, serviceEvent.getId())),
                                serviceEvent));
            }
        } catch (KapuaException e) {
            throw new RuntimeException(e);
        }
        // update event id on Event
        // persistedKapuaEvent.getId() cannot be null since is generated by the database
        serviceEvent.setId(persistedKapuaEvent.getId().toCompactId());
    }

    private boolean isNewEvent(org.eclipse.kapua.event.ServiceEvent event) {
        return (event.getId() == null);
    }
}
