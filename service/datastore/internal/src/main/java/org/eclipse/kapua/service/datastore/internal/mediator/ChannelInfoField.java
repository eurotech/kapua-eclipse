/*******************************************************************************
 * Copyright (c) 2011, 2017 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *  
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.service.datastore.internal.mediator;

import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.datastore.internal.schema.ChannelInfoSchema;
import org.eclipse.kapua.service.datastore.model.ChannelInfo;
import org.eclipse.kapua.service.datastore.model.ChannelInfoCreator;
import org.eclipse.kapua.service.datastore.model.StorableId;
import org.eclipse.kapua.service.datastore.model.query.StorableField;

/**
 * This enumeration defines the fields names used in the {@link ChannelInfo} client schema
 * 
 * @since 1.0
 *
 */
public enum ChannelInfoField implements StorableField {
    /**
     * Channel
     */
    CHANNEL(ChannelInfoSchema.CHANNEL_NAME),
    /**
     * Client identifier
     */
    CLIENT_ID(ChannelInfoSchema.CHANNEL_CLIENT_ID),
    /**
     * Scope id
     */
    SCOPE_ID(ChannelInfoSchema.CHANNEL_SCOPE_ID),
    /**
     * Timestamp
     */
    TIMESTAMP(ChannelInfoSchema.CHANNEL_TIMESTAMP),
    /**
     * Message identifier
     */
    MESSAGE_ID(ChannelInfoSchema.CHANNEL_MESSAGE_ID);

    private String field;

    private ChannelInfoField(String name) {
        this.field = name;
    }

    @Override
    public String field() {
        return field;
    }

    /**
     * Get the channel identifier (combining accountName clientId and c).<br>
     * <b>If the id is null then it is generated</b>
     * 
     * @param id
     * @param scopeId
     * @param clientId
     * @param channel
     * @return
     */
    private static String getOrDeriveId(StorableId id, KapuaId scopeId, String clientId, String channel) {
        if (id == null) {
            return DatastoreUtils.getHashCode(scopeId.toCompactId(), clientId, channel);
        } else {
            return id.toString();
        }
    }

    /**
     * Get the channel identifier getting parameters from the metricInfoCreator. Then it calls {@link getOrDeriveId(StorableId id, KapuaId scopeId, String clientId, String channel)}
     * 
     * @param id
     * @param channelInfoCreator
     * @return
     */
    public static String getOrDeriveId(StorableId id, ChannelInfoCreator channelInfoCreator) {
        return getOrDeriveId(id,
                channelInfoCreator.getScopeId(),
                channelInfoCreator.getClientId(),
                channelInfoCreator.getName());
    }

    /**
     * Get the channel identifier getting parameters from the channelInfo. Then it calls {@link getOrDeriveId(StorableId id, KapuaId scopeId, String clientId, String channel)}
     * 
     * @param id
     * @param channelInfo
     * @return
     */
    public static String getOrDeriveId(StorableId id, ChannelInfo channelInfo) {
        return getOrDeriveId(id,
                channelInfo.getScopeId(),
                channelInfo.getClientId(),
                channelInfo.getName());
    }

}
