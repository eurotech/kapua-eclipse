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
package org.eclipse.kapua.service.datastore.internal;

import org.eclipse.kapua.KapuaIllegalArgumentException;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.datastore.internal.mediator.Metric;
import org.eclipse.kapua.service.datastore.model.DatastoreMessage;
import org.eclipse.kapua.service.datastore.model.query.MessageQuery;
import org.eclipse.kapua.service.elasticsearch.client.exception.ClientException;
import org.eclipse.kapua.service.storable.exception.MappingException;
import org.eclipse.kapua.service.storable.model.id.StorableId;

import java.util.Map;

public interface MessageRepository extends DatastoreRepository<DatastoreMessage, MessageQuery> {

    String store(DatastoreMessage messageToStore) throws ClientException;

    DatastoreMessage find(KapuaId scopeId, String indexName, StorableId id)
            throws KapuaIllegalArgumentException, ClientException;

    void refreshAllIndexes() throws ClientException;

    void deleteAllIndexes() throws ClientException;

    void deleteIndexes(String indexExp) throws ClientException;

    void upsertMappings(KapuaId scopeId, Map<String, Metric> esMetrics) throws ClientException, MappingException;

    void upsertIndex(String dataIndexName) throws ClientException, MappingException;

    void delete(KapuaId scopeId, String id, long time) throws ClientException;
}
