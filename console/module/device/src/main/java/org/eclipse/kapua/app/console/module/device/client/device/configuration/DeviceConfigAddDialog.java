/*******************************************************************************
 * Copyright (c) 2025 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.app.console.module.device.client.device.configuration;

import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.rpc.AsyncCallback;
import org.eclipse.kapua.app.console.module.api.client.messages.ConsoleMessages;
import org.eclipse.kapua.app.console.module.api.client.ui.dialog.entity.EntityAddEditDialog;
import org.eclipse.kapua.app.console.module.api.client.ui.panel.FormPanel;
import org.eclipse.kapua.app.console.module.api.client.ui.widget.KapuaTextField;
import org.eclipse.kapua.app.console.module.api.client.util.ConsoleInfo;
import org.eclipse.kapua.app.console.module.api.client.util.DialogUtils;
import org.eclipse.kapua.app.console.module.api.client.util.FailureHandler;
import org.eclipse.kapua.app.console.module.api.shared.model.GwtConfigComponentCreator;
import org.eclipse.kapua.app.console.module.api.shared.model.session.GwtSession;
import org.eclipse.kapua.app.console.module.device.client.messages.ConsoleDeviceMessages;
import org.eclipse.kapua.app.console.module.device.shared.model.GwtDevice;
import org.eclipse.kapua.app.console.module.device.shared.service.GwtDeviceManagementService;
import org.eclipse.kapua.app.console.module.device.shared.service.GwtDeviceManagementServiceAsync;

public class DeviceConfigAddDialog extends EntityAddEditDialog {

    private static final ConsoleDeviceMessages MSGS = GWT.create(ConsoleDeviceMessages.class);
    private static final ConsoleMessages CONSOLE_MSGS = GWT.create(ConsoleMessages.class);

    private static final GwtDeviceManagementServiceAsync GWT_DEVICE_MANAGEMENT_SERVICE = GWT.create(GwtDeviceManagementService.class);

    private final GwtDevice device;

    private KapuaTextField<String> componentFactoryIdField;
    private KapuaTextField<String> componentIdField;

    public DeviceConfigAddDialog(GwtSession currentSession, GwtDevice device) {
        super(currentSession);
        this.device = device;
        DialogUtils.resizeDialog(this, 400, 200);
    }

    @Override
    public void createBody() {
        submitButton.disable();
        FormPanel roleFormPanel = new FormPanel(FORM_LABEL_WIDTH);
        // Name
        componentFactoryIdField = new KapuaTextField<String>();
        componentFactoryIdField.setAllowBlank(false);
        componentFactoryIdField.setMaxLength(255);
        componentFactoryIdField.setFieldLabel("* " + MSGS.dialogDeviceConfigComponentAddComponentFactoryIdFieldName());
        roleFormPanel.add(componentFactoryIdField);

        componentIdField = new KapuaTextField<String>();
        componentIdField.setAllowBlank(false);
        componentIdField.setMaxLength(255);
        componentIdField.setFieldLabel("* " + MSGS.dialogDeviceConfigComponentAddComponentIdFieldName());
        roleFormPanel.add(componentIdField);

        bodyPanel.add(roleFormPanel);
    }

    @Override
    protected void preSubmit() {
        if (componentFactoryIdField.getValue() == null || componentIdField.getValue() == null) {
            ConsoleInfo.display("Error", CONSOLE_MSGS.allFieldsRequired());
        }
        super.preSubmit();
    }

    @Override
    public void submit() {
        GwtConfigComponentCreator creator = new GwtConfigComponentCreator();
        creator.setComponentFactoryId(componentFactoryIdField.getValue());
        creator.setComponentId(componentIdField.getValue());

        GWT_DEVICE_MANAGEMENT_SERVICE.createComponentConfiguration(xsrfToken, device, creator, new AsyncCallback<Void>() {

            @Override
            public void onSuccess(Void result) {
                exitStatus = true;
                exitMessage = MSGS.dialogDeviceConfigComponentAddConfirmation();
                hide();
            }

            @Override
            public void onFailure(Throwable cause) {
                exitStatus = false;
                status.hide();
                formPanel.getButtonBar().enable();
                unmask();
                submitButton.enable();
                cancelButton.enable();

                FailureHandler.handleFormException(formPanel, cause);
            }

        });
    }

    @Override
    public String getHeaderMessage() {
        return MSGS.dialogDeviceConfigComponentAddHeader();
    }

    @Override
    public String getInfoMessage() {
        return MSGS.dialogDeviceConfigComponentAddInfo();
    }
}
