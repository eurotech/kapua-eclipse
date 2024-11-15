/*******************************************************************************
 * Copyright (c) 2022 Eurotech and/or its affiliates and others
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *     Eurotech
 *******************************************************************************/
package org.eclipse.kapua.broker.artemis.plugin.security;

import org.eclipse.kapua.broker.artemis.plugin.security.connector.AcceptorHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Class to intercept Broker lifecycle events
 */
public class ActivateCallback implements org.apache.activemq.artemis.core.server.ActivateCallback {

    private final Logger logger = LoggerFactory.getLogger(ActivateCallback.class);

    private final AcceptorHandler acceptorHandler;

    public ActivateCallback(AcceptorHandler acceptorHandler) {
        this.acceptorHandler = acceptorHandler;
    }

    @Override
    /**
     * Use this callback to start Acceptors for now (but could be used to do whatever needs to have a fully running broker
     */
    public void activationComplete() {
        logger.info("Broker activation completed!");
        org.apache.activemq.artemis.core.server.ActivateCallback.super.activationComplete();
        logger.info("Creating acceptors...");
        try {
            acceptorHandler.syncAcceptors();
        } catch (Exception e) {
            logger.error("Creating acceptors... ERROR: {}", e.getMessage(), e);
            //TODO throw runtime? the broker doesn't work properly if not all the acceptors are created
        }
        logger.info("Creating acceptors... DONE");
    }

}
