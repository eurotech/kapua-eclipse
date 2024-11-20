/*******************************************************************************
 * Copyright (c) 2017, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.app.console.module.job.client.schedule;

import com.extjs.gxt.ui.client.data.BaseListLoader;
import com.extjs.gxt.ui.client.data.ListLoadResult;
import com.extjs.gxt.ui.client.data.RpcProxy;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.HorizontalPanel;
import com.extjs.gxt.ui.client.widget.Label;
import com.extjs.gxt.ui.client.widget.form.ComboBox;
import com.extjs.gxt.ui.client.widget.form.ComboBox.TriggerAction;
import com.extjs.gxt.ui.client.widget.form.FieldSet;
import com.extjs.gxt.ui.client.widget.form.LabelField;
import com.extjs.gxt.ui.client.widget.form.TimeField;
import com.google.gwt.core.client.GWT;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.google.gwt.user.client.rpc.AsyncCallback;
import org.eclipse.kapua.app.console.module.api.client.GwtKapuaErrorCode;
import org.eclipse.kapua.app.console.module.api.client.GwtKapuaException;
import org.eclipse.kapua.app.console.module.api.client.messages.ConsoleMessages;
import org.eclipse.kapua.app.console.module.api.client.messages.ValidationMessages;
import org.eclipse.kapua.app.console.module.api.client.ui.dialog.entity.EntityAddEditDialog;
import org.eclipse.kapua.app.console.module.api.client.ui.panel.FormPanel;
import org.eclipse.kapua.app.console.module.api.client.ui.widget.KapuaDateField;
import org.eclipse.kapua.app.console.module.api.client.ui.widget.KapuaNumberField;
import org.eclipse.kapua.app.console.module.api.client.ui.widget.KapuaTextField;
import org.eclipse.kapua.app.console.module.api.client.util.ConsoleInfo;
import org.eclipse.kapua.app.console.module.api.client.util.CssLiterals;
import org.eclipse.kapua.app.console.module.api.client.util.DialogUtils;
import org.eclipse.kapua.app.console.module.api.client.util.FailureHandler;
import org.eclipse.kapua.app.console.module.api.client.util.validator.AfterDateValidator;
import org.eclipse.kapua.app.console.module.api.client.util.validator.BeforeDateValidator;
import org.eclipse.kapua.app.console.module.api.client.util.validator.TextFieldValidator;
import org.eclipse.kapua.app.console.module.api.shared.model.session.GwtSession;
import org.eclipse.kapua.app.console.module.job.client.messages.ConsoleJobMessages;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.GwtTrigger;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.GwtTriggerCreator;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.GwtTriggerProperty;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.definition.GwtTriggerDefinition;
import org.eclipse.kapua.app.console.module.job.shared.model.scheduler.definition.GwtTriggerDefinitionQuery;
import org.eclipse.kapua.app.console.module.job.shared.service.GwtTriggerDefinitionService;
import org.eclipse.kapua.app.console.module.job.shared.service.GwtTriggerDefinitionServiceAsync;
import org.eclipse.kapua.app.console.module.job.shared.service.GwtTriggerService;
import org.eclipse.kapua.app.console.module.job.shared.service.GwtTriggerServiceAsync;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class JobScheduleAddDialog extends EntityAddEditDialog {

    protected static final ConsoleJobMessages JOB_MSGS = GWT.create(ConsoleJobMessages.class);
    protected static final ConsoleMessages CONSOLE_MSGS = GWT.create(ConsoleMessages.class);
    private static final ValidationMessages VAL_MSGS = GWT.create(ValidationMessages.class);

    private static final GwtTriggerServiceAsync GWT_TRIGGER_SERVICE = GWT.create(GwtTriggerService.class);
    private static final GwtTriggerDefinitionServiceAsync GWT_TRIGGER_DEFINITION_SERVICE = GWT.create(GwtTriggerDefinitionService.class);

    private static final String KAPUA_ID_CLASS_NAME = "org.eclipse.kapua.model.id.KapuaId";

    private static final String TRIGGER_DEFINITION_NAME_INTERVAL = "Interval Job";
    private static final String TRIGGER_DEFINITION_NAME_CRON = "Cron Job";
    private static final String TRIGGER_DEFINITION_NAME_DEVICE_CONNECT = "Device Connect";
    private static final String DATE_FORMAT = "dd/MM/yyyy";

    private final String jobId;

    protected final KapuaTextField<String> triggerName;
    protected final KapuaDateField startsOn;
    protected final TimeField startsOnTime;
    protected final KapuaDateField endsOn;
    protected final TimeField endsOnTime;

    protected final ComboBox<GwtTriggerDefinition> triggerDefinitionCombo;
    protected final FieldSet triggerPropertiesFieldSet;
    protected final Label triggerDefinitionDescription;
    protected final FormPanel triggerPropertiesPanel;


    protected final KapuaNumberField retryInterval;
    protected final KapuaTextField<String> cronExpression;
    protected Label startsOnLabel;
    protected Label endsOnLabel;
    protected LabelField cronExpressionLabel;

    public JobScheduleAddDialog(GwtSession currentSession, String jobId) {
        super(currentSession);
        this.jobId = jobId;

        triggerName = new KapuaTextField<String>();
        startsOn = new KapuaDateField(this);
        startsOn.setMaxLength(10);
        startsOn.getPropertyEditor().setFormat(DateTimeFormat.getFormat(DATE_FORMAT));
        startsOnTime = new TimeField();
        startsOnTime.setEditable(false);
        endsOn = new KapuaDateField(this);
        endsOn.setMaxLength(10);
        endsOn.getPropertyEditor().setFormat(DateTimeFormat.getFormat(DATE_FORMAT));
        endsOnTime = new TimeField();
        endsOnTime.setEditable(false);
        startsOnLabel = new Label();
        endsOnLabel = new Label();

        triggerDefinitionCombo = new ComboBox<GwtTriggerDefinition>();
        triggerPropertiesFieldSet = new FieldSet();
        triggerDefinitionDescription = new Label();
        triggerPropertiesPanel = new FormPanel(FORM_LABEL_WIDTH);

        retryInterval = new KapuaNumberField();
        cronExpression = new KapuaTextField<String>();

        DialogUtils.resizeDialog(this, 500, 370);
    }

    @Override
    public void createBody() {
        submitButton.disable();

        FormPanel mainPanel = new FormPanel(140);
        Listener<BaseEvent> listener = new Listener<BaseEvent>() {

            @Override
            public void handleEvent(BaseEvent be) {
                formPanel.fireEvent(Events.OnClick);
            }
        };

        triggerName.setAllowBlank(false);
        triggerName.setMinLength(3);
        triggerName.setMaxLength(255);
        triggerName.setValidator(new TextFieldValidator(triggerName, TextFieldValidator.FieldType.EXTENDED_NAME));
        triggerName.setFieldLabel("* " + JOB_MSGS.dialogAddScheduleScheduleNameLabel());
        triggerName.setToolTip(JOB_MSGS.dialogAddScheduleNameTooltip());
        mainPanel.add(triggerName);

        startsOnLabel.setText("* " + JOB_MSGS.dialogAddScheduleStartsOnLabel());
        startsOnLabel.setWidth(FORM_LABEL_WIDTH);
        startsOnLabel.setStyleAttribute(CssLiterals.PADDING, "0px 88px 0px 0px");

        startsOn.setFormatValue(true);
        startsOn.setAllowBlank(false);
        startsOn.setWidth(140);
        startsOn.setEmptyText(JOB_MSGS.dialogAddScheduleDatePlaceholder());
        startsOn.getPropertyEditor().setFormat(DateTimeFormat.getFormat(DATE_FORMAT));
        startsOn.setToolTip(JOB_MSGS.dialogAddScheduleStartsOnTooltip());
        startsOn.setValidator(new AfterDateValidator(endsOn));
        startsOn.getDatePicker().addListener(Events.Select, listener);
        startsOn.setValue(new Date());
        startsOn.setMinValue(new Date());
        startsOn.getMessages().setMinText(JOB_MSGS.dialogAddScheduleStartsOnDateMin(DateTimeFormat.getFormat(DATE_FORMAT).format(startsOn.getMinValue())));

        startsOnTime.setFormat(DateTimeFormat.getFormat("HH:mm"));
        startsOnTime.setAllowBlank(false);
        startsOnTime.setEditable(false);
        startsOnTime.setWidth(140);
        startsOnTime.setStyleAttribute("position", "relative");
        startsOnTime.setStyleAttribute("left", "26px");
        startsOnTime.setEmptyText(JOB_MSGS.dialogAddScheduleTimePlaceholder());
        startsOnTime.setToolTip(JOB_MSGS.dialogAddScheduleStartsOnTimeTooltip());
        startsOnTime.setTriggerAction(TriggerAction.ALL);
        startsOnTime.addListener(Events.Select, listener);
        startsOnTime.setDateValue(new Date());

        HorizontalPanel startsOnPanel = new HorizontalPanel();
        startsOnPanel.add(startsOnLabel);
        startsOnPanel.add(startsOn);
        startsOnPanel.add(startsOnTime);
        mainPanel.add(startsOnPanel);

        endsOnLabel.setText(JOB_MSGS.dialogAddScheduleEndsOnLabel());
        endsOnLabel.setStyleAttribute("margin-left", "10px");
        endsOnLabel.setWidth(FORM_LABEL_WIDTH);
        endsOnLabel.setStyleAttribute(CssLiterals.PADDING, "0px 92px 0px 0px");

        endsOn.setFormatValue(true);
        endsOn.setWidth(140);
        endsOn.setEmptyText(JOB_MSGS.dialogAddScheduleDatePlaceholder());
        endsOn.getPropertyEditor().setFormat(DateTimeFormat.getFormat(DATE_FORMAT));
        endsOn.setToolTip(JOB_MSGS.dialogAddScheduleEndsOnTooltip());
        endsOn.setValidator(new BeforeDateValidator(startsOn));
        endsOn.getDatePicker().addListener(Events.Select, listener);
        endsOn.setMinValue(new Date());
        endsOn.getMessages().setMinText(JOB_MSGS.dialogAddScheduleStartsOnDateMin(DateTimeFormat.getFormat(DATE_FORMAT).format(endsOn.getMinValue())));

        endsOnTime.setFormat(DateTimeFormat.getFormat("HH:mm"));
        endsOnTime.setEditable(false);
        endsOnTime.setWidth(140);
        endsOnTime.setStyleAttribute("position", "relative");
        endsOnTime.setStyleAttribute("left", "26px");
        endsOnTime.setEmptyText(JOB_MSGS.dialogAddScheduleTimePlaceholder());
        endsOnTime.setToolTip(JOB_MSGS.dialogAddScheduleEndsOnTimeTooltip());
        endsOnTime.setTriggerAction(TriggerAction.ALL);
        endsOnTime.addListener(Events.Select, listener);

        HorizontalPanel endsOnPanel = new HorizontalPanel();
        endsOnPanel.setStyleAttribute(CssLiterals.PADDING, "4px 0px 4px 0px");
        endsOnPanel.add(endsOnLabel);
        endsOnPanel.add(endsOn);
        endsOnPanel.add(endsOnTime);
        mainPanel.add(endsOnPanel);

        GwtTriggerDefinitionQuery query = new GwtTriggerDefinitionQuery();
        query.setScopeId(currentSession.getSelectedAccountId());
        RpcProxy<ListLoadResult<GwtTriggerDefinition>> triggerDefinitionProxy = new RpcProxy<ListLoadResult<GwtTriggerDefinition>>() {

            @Override
            protected void load(Object loadConfig, AsyncCallback<ListLoadResult<GwtTriggerDefinition>> callback) {
                GWT_TRIGGER_DEFINITION_SERVICE.findAll(callback);
            }
        };

        BaseListLoader<ListLoadResult<GwtTriggerDefinition>> triggerDefinitionLoader = new BaseListLoader<ListLoadResult<GwtTriggerDefinition>>(triggerDefinitionProxy);
        triggerDefinitionLoader.addLoadListener(new DialogLoadListener());
        ListStore<GwtTriggerDefinition> triggerDefinitionStore = new ListStore<GwtTriggerDefinition>(triggerDefinitionLoader);
        triggerDefinitionCombo.setStore(triggerDefinitionStore);
        triggerDefinitionCombo.setDisplayField("triggerDefinitionName");
        triggerDefinitionCombo.setFieldLabel("* " + JOB_MSGS.dialogAddScheduleDefinitionCombo());
        triggerDefinitionCombo.setToolTip(JOB_MSGS.dialogAddScheduleDefinitionComboTooltip());
        triggerDefinitionCombo.setEmptyText(JOB_MSGS.dialogAddScheduleDefinitionComboEmpty());
        triggerDefinitionCombo.setEditable(false);
        triggerDefinitionCombo.setAllowBlank(false);
        triggerDefinitionCombo.setForceSelection(true);
        triggerDefinitionCombo.setTypeAhead(false);
        triggerDefinitionCombo.setTriggerAction(TriggerAction.ALL);
        triggerDefinitionCombo.addSelectionChangedListener(new SelectionChangedListener<GwtTriggerDefinition>() {

            @Override
            public void selectionChanged(SelectionChangedEvent<GwtTriggerDefinition> selectionChangedEvent) {
                refreshTriggerDefinition(selectionChangedEvent.getSelectedItem());
            }
        });
        mainPanel.add(triggerDefinitionCombo);

        triggerDefinitionDescription.setStyleAttribute("display", "block");

        triggerPropertiesFieldSet.setHeading(JOB_MSGS.dialogAddTriggerPropertiesFieldSetHeading());
        triggerPropertiesFieldSet.setVisible(false);
        triggerPropertiesFieldSet.add(triggerDefinitionDescription);
        triggerPropertiesFieldSet.add(triggerPropertiesPanel);
        mainPanel.add(triggerPropertiesFieldSet);

        bodyPanel.add(mainPanel);

    }

    private void refreshTriggerDefinition(GwtTriggerDefinition gwtTriggerDefinition) {
        triggerPropertiesFieldSet.setVisible(true);
        triggerDefinitionDescription.setText(gwtTriggerDefinition.getDescription() + ".");
        triggerPropertiesPanel.removeAll();

        if (TRIGGER_DEFINITION_NAME_INTERVAL.equals(gwtTriggerDefinition.getTriggerDefinitionName())) {
            retryInterval.clearInvalid();
            retryInterval.setFieldLabel("* " + JOB_MSGS.dialogAddScheduleRetryIntervalLabel());
            retryInterval.setAllowBlank(false);
            retryInterval.setAllowDecimals(false);
            retryInterval.setMinValue(1);
            retryInterval.setMaxLength(9);
            retryInterval.setToolTip(JOB_MSGS.dialogAddScheduleRetryIntervalTooltip());
            triggerPropertiesPanel.add(retryInterval);

            GwtTriggerProperty triggerProperty = gwtTriggerDefinition.getTriggerProperty("interval");

            if (triggerProperty != null && triggerProperty.getDescription() != null) {
                LabelField fieldTooltip = new LabelField();
                fieldTooltip.setStyleAttribute("margin-top", "-5px");
                fieldTooltip.setStyleAttribute("color", "gray");
                fieldTooltip.setStyleAttribute("font-size", "10px");
                fieldTooltip.setValue(triggerProperty.getDescription());

                triggerPropertiesPanel.add(fieldTooltip);
            }

        } else if (TRIGGER_DEFINITION_NAME_CRON.equals(gwtTriggerDefinition.getTriggerDefinitionName())) {
            cronExpression.clearInvalid();
            cronExpression.setFieldLabel("* " + JOB_MSGS.dialogAddScheduleCronScheduleLabel());
            cronExpression.setAllowBlank(false);
            cronExpression.setMaxLength(255);
            cronExpression.setToolTip(JOB_MSGS.dialogAddScheduleCronTooltip());
            triggerPropertiesPanel.add(cronExpression);

            cronExpressionLabel = new LabelField();
            cronExpressionLabel.setValue(JOB_MSGS.dialogAddScheduleCronDescriptionLabel());
            cronExpressionLabel.setStyleAttribute("margin-top", "-5px");
            cronExpressionLabel.setStyleAttribute("color", "gray");
            cronExpressionLabel.setStyleAttribute("font-size", "10px");
            triggerPropertiesPanel.add(cronExpressionLabel);

            GwtTriggerProperty triggerProperty = gwtTriggerDefinition.getTriggerProperty("cronExpression");

            if (triggerProperty != null && triggerProperty.getDescription() != null) {
                LabelField fieldTooltip = new LabelField();
                fieldTooltip.setStyleAttribute("margin-top", "-5px");
                fieldTooltip.setStyleAttribute("color", "gray");
                fieldTooltip.setStyleAttribute("font-size", "10px");
                fieldTooltip.setValue(triggerProperty.getDescription());

                triggerPropertiesPanel.add(fieldTooltip);
            }

            cronExpression.addListener(Events.Blur, new Listener<BaseEvent>() {
                @Override
                public void handleEvent(BaseEvent baseEvent) {
                    GWT_TRIGGER_SERVICE.validateCronExpression(cronExpression.getValue(), new AsyncCallback<Boolean>() {
                        @Override
                        public void onFailure(Throwable caught) {
                            ConsoleInfo.display(MSGS.popupError(), JOB_MSGS.dialogAddScheduleCronUnableToValidate());
                            cronExpression.markInvalid(VAL_MSGS.invalidCronExpression());
                        }

                        @Override
                        public void onSuccess(Boolean result) {
                            if (!result) {
                                cronExpression.markInvalid(VAL_MSGS.invalidCronExpression());
                            }
                        }
                    });
                }
            });
        } else if (TRIGGER_DEFINITION_NAME_DEVICE_CONNECT.equals(gwtTriggerDefinition.getTriggerDefinitionName())) {
            // No field to render
        }

        triggerPropertiesPanel.layout(true);
    }

    public boolean validateDateTimeRange() {
        startsOn.clearInvalid();
        startsOnTime.clearInvalid();
        endsOn.clearInvalid();
        endsOnTime.clearInvalid();

        Date startDate = startsOn.getValue();
        if (startDate == null) {
            startsOn.validate();
        }

        startDate.setHours(startsOnTime.getValue().getHour());
        startDate.setMinutes(startsOnTime.getValue().getMinutes());

        if (endsOn.getValue() == null && endsOnTime.getValue() == null) {
            return true;
        }

        if (endsOn.getValue() != null && endsOnTime.getValue() == null) {
            endsOnTime.markInvalid(VAL_MSGS.endDateWithoutEndTime());
            return false;
        }
        if (endsOn.getValue() == null && endsOnTime.getValue() != null) {
            endsOn.markInvalid(VAL_MSGS.endTimeWithoutEndDate());
            return false;
        }

        Date endDate = endsOn.getValue();
        endDate.setHours(endsOnTime.getValue().getHour());
        endDate.setMinutes(endsOnTime.getValue().getMinutes());

        if (startDate.after(endDate)) {

            if (startsOn.getValue().after(endsOn.getValue())) {
                startsOn.markInvalid(VAL_MSGS.startsOnDateLaterThanEndsOn());
            } else {
                startsOnTime.markInvalid(VAL_MSGS.startsOnTimeLaterThanEndsOn());
            }
            return false;
        }

        if (new Date().after(endDate)) {
            endsOn.markInvalid(VAL_MSGS.endDateOutOfTime());
            endsOnTime.markInvalid(VAL_MSGS.endDateOutOfTime());
            return false;
        }

        return true;
    }

    @Override
    protected void preSubmit() {

        if (!validateDateTimeRange()) {
            return;
        }

        if (!triggerPropertiesPanel.isValid()) {
            return;
        }

        super.preSubmit();
    }

    @Override
    public void submit() {
        GwtTriggerCreator gwtTriggerCreator = new GwtTriggerCreator();

        gwtTriggerCreator.setScopeId(currentSession.getSelectedAccountId());
        gwtTriggerCreator.setTriggerName(triggerName.getValue());

        Date startDate = startsOn.getValue();
        startDate.setHours(startsOnTime.getValue().getHour());
        startDate.setMinutes(startsOnTime.getValue().getMinutes());
        gwtTriggerCreator.setStartsOn(startDate);

        if (endsOn.getValue() != null && endsOnTime.getValue() != null) {
            Date endDate = endsOn.getValue();
            endDate.setHours(endsOnTime.getValue().getHour());
            endDate.setMinutes(endsOnTime.getValue().getMinutes());
            gwtTriggerCreator.setEndsOn(endDate);
        }

        gwtTriggerCreator.setTriggerType(triggerDefinitionCombo.getSelection().get(0).getTriggerDefinitionName());

        List<GwtTriggerProperty> gwtTriggerPropertyList = new ArrayList<GwtTriggerProperty>();
        gwtTriggerPropertyList.add(new GwtTriggerProperty("scopeId", KAPUA_ID_CLASS_NAME, currentSession.getSelectedAccountId()));
        gwtTriggerPropertyList.add(new GwtTriggerProperty("jobId", KAPUA_ID_CLASS_NAME, jobId));
        gwtTriggerCreator.setTriggerProperties(gwtTriggerPropertyList);

        gwtTriggerCreator.setRetryInterval(retryInterval.getValue() != null ? retryInterval.getValue().longValue() : null);
        gwtTriggerCreator.setCronScheduling(cronExpression.getValue());

        GWT_TRIGGER_SERVICE.create(xsrfToken, gwtTriggerCreator, new AsyncCallback<GwtTrigger>() {

            @Override
            public void onSuccess(GwtTrigger gwtTrigger) {
                exitStatus = true;
                exitMessage = JOB_MSGS.dialogAddScheduleConfirmation();
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
                if (!isPermissionErrorMessage(cause)) {
                    if (cause instanceof GwtKapuaException) {
                        GwtKapuaException gwtCause = (GwtKapuaException) cause;
                        if (gwtCause.getCode().equals(GwtKapuaErrorCode.DUPLICATE_NAME)) {
                            triggerName.markInvalid("Another Job Trigger has the same name.");
                        } else if (gwtCause.getCode().equals(GwtKapuaErrorCode.RETRY_AND_CRON_BOTH_SELECTED)) {
                            cronExpression.markInvalid(gwtCause.getMessage());
                            retryInterval.markInvalid(gwtCause.getMessage());
                        } else if (gwtCause.getCode().equals(GwtKapuaErrorCode.SAME_START_AND_DATE)) {
                            startsOn.markInvalid(gwtCause.getMessage());
                            startsOnTime.markInvalid(gwtCause.getMessage());
                            endsOn.markInvalid(gwtCause.getMessage());
                            endsOnTime.markInvalid(gwtCause.getMessage());
                        } else if (gwtCause.getCode().equals(GwtKapuaErrorCode.TRIGGER_NEVER_FIRE)) {
                            startsOn.markInvalid(gwtCause.getMessage());
                            startsOnTime.markInvalid(gwtCause.getMessage());
                            cronExpression.markInvalid(gwtCause.getMessage());
                            retryInterval.markInvalid(gwtCause.getMessage());
                        }
                    }
                    FailureHandler.handleFormException(formPanel, cause);
                }
            }
        });
    }

    @Override
    public String getHeaderMessage() {
        return JOB_MSGS.dialogAddScheduleHeader();
    }

    @Override
    public String getInfoMessage() {
        return JOB_MSGS.dialogAddScheduleInfo();
    }
}
