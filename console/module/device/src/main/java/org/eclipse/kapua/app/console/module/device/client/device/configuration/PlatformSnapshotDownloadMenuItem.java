/*******************************************************************************
 * Copyright (c) 2017 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.app.console.module.device.client.device.configuration;

import org.eclipse.kapua.app.console.module.api.client.resources.icons.IconSet;
import org.eclipse.kapua.app.console.module.api.client.ui.widget.KapuaMenuItem;
import org.eclipse.kapua.app.console.module.device.client.messages.ConsoleDeviceMessages;

import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.google.gwt.core.client.GWT;

public class PlatformSnapshotDownloadMenuItem extends KapuaMenuItem {

    private static final ConsoleDeviceMessages MSGS = GWT.create(ConsoleDeviceMessages.class);

    public PlatformSnapshotDownloadMenuItem(SelectionListener<MenuEvent> listener) {
        super(MSGS.buttonPlatformSnapshotDownload(),
                IconSet.CLOUD_DOWNLOAD,
                listener);
    }
}
