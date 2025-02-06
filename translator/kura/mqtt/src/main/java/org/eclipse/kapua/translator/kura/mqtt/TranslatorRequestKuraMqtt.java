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
package org.eclipse.kapua.translator.kura.mqtt;

import com.google.common.base.Strings;
import com.google.inject.Inject;
import org.eclipse.kapua.service.device.call.message.kura.KuraPayload;
import org.eclipse.kapua.service.device.call.message.kura.app.request.KuraRequestChannel;
import org.eclipse.kapua.service.device.call.message.kura.app.request.KuraRequestMessage;
import org.eclipse.kapua.service.device.call.message.kura.data.KuraDataChannel;
import org.eclipse.kapua.service.device.call.message.kura.setting.DeviceCallSettingKeys;
import org.eclipse.kapua.service.device.call.message.kura.setting.DeviceCallSettings;
import org.eclipse.kapua.translator.Translator;
import org.eclipse.kapua.translator.exception.InvalidChannelException;
import org.eclipse.kapua.translator.exception.InvalidMessageException;
import org.eclipse.kapua.translator.exception.InvalidPayloadException;
import org.eclipse.kapua.translator.exception.TranslateException;
import org.eclipse.kapua.transport.message.mqtt.MqttMessage;
import org.eclipse.kapua.transport.message.mqtt.MqttPayload;
import org.eclipse.kapua.transport.message.mqtt.MqttTopic;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * {@link Translator} implementation from {@link KuraRequestMessage} to {@link MqttMessage}
 *
 * @since 1.0.0
 */
public class TranslatorRequestKuraMqtt extends Translator<KuraRequestMessage, MqttMessage> {

    private final String replyPart;

    @Inject
    public TranslatorRequestKuraMqtt(DeviceCallSettings deviceCallSettings) {
        replyPart = deviceCallSettings.getString(DeviceCallSettingKeys.DESTINATION_REPLY_PART);
    }

    @Override
    public MqttMessage translate(KuraRequestMessage kuraRequestMessage) throws TranslateException {
        try {
            // Mqtt request topic
            MqttTopic mqttRequestTopic = translate(kuraRequestMessage.getChannel());

            // Mqtt response topic
            MqttTopic mqttResponseTopic = generateResponseTopic(kuraRequestMessage.getChannel());

            // Mqtt payload
            MqttPayload mqttPayload = translate(kuraRequestMessage.getPayload());

            // Return Mqtt message
            return new MqttMessage(mqttRequestTopic, mqttResponseTopic, mqttPayload);
        } catch (InvalidChannelException | InvalidPayloadException te) {
            throw te;
        } catch (Exception e) {
            throw new InvalidMessageException(e, kuraRequestMessage);
        }
    }

    /**
     * Translates the given {@link KuraRequestChannel} to the {@link MqttTopic} equivalent.
     *
     * @param kuraRequestChannel The {@link KuraDataChannel} to translate.
     * @return The translated {@link MqttTopic}
     * @throws InvalidChannelException if translation encounters any error.
     * @since 1.0.0
     */
    public MqttTopic translate(KuraRequestChannel kuraRequestChannel) throws InvalidChannelException {
        try {
            List<String> topicTokens = new ArrayList<>();

            if (kuraRequestChannel.getMessageClassification() != null) {
                topicTokens.add(kuraRequestChannel.getMessageClassification());
            }

            topicTokens.add(kuraRequestChannel.getScope());
            topicTokens.add(kuraRequestChannel.getClientId());

            if (!Strings.isNullOrEmpty(kuraRequestChannel.getAppId())) {
                topicTokens.add(kuraRequestChannel.getAppId());
            }

            if (kuraRequestChannel.getMethod() != null) {
                topicTokens.add(kuraRequestChannel.getMethod().name());
            }

            Collections.addAll(topicTokens, kuraRequestChannel.getResources());

            // Return Mqtt Topic
            return new MqttTopic(topicTokens.toArray(new String[0]));
        } catch (Exception e) {
            throw new InvalidChannelException(e, kuraRequestChannel);
        }
    }

    /**
     * Generates the response {@link MqttTopic} for the given {@link KuraRequestChannel}.
     *
     * @param kuraRequestChannel The {@link KuraRequestChannel}
     * @return The response {@link MqttTopic}.
     * @throws InvalidChannelException if generation encounters any error.
     * @since 1.0.0
     */
    public MqttTopic generateResponseTopic(KuraRequestChannel kuraRequestChannel) throws InvalidChannelException {
        try {
            List<String> topicTokens = new ArrayList<>();

            if (kuraRequestChannel.getMessageClassification() != null) {
                topicTokens.add(kuraRequestChannel.getMessageClassification());
            }

            topicTokens.add(kuraRequestChannel.getScope());
            topicTokens.add(kuraRequestChannel.getRequesterClientId());
            topicTokens.add(kuraRequestChannel.getAppId());
            topicTokens.add(replyPart);
            topicTokens.add(kuraRequestChannel.getRequestId());

            return new MqttTopic(topicTokens.toArray(new String[0]));
        } catch (Exception e) {
            throw new InvalidChannelException(e, kuraRequestChannel);
        }
    }

    /**
     * Translates the given {@link KuraPayload} to the {@link MqttPayload} equivalent.
     *
     * @param kuraPayload The {@link KuraDataChannel} to translate.
     * @return The translated {@link MqttPayload}
     * @throws InvalidPayloadException if translation encounters any error.
     * @since 1.0.0
     */
    public MqttPayload translate(KuraPayload kuraPayload) throws InvalidPayloadException {
        try {
            return new MqttPayload(kuraPayload.toByteArray());
        } catch (Exception e) {
            throw new InvalidPayloadException(e, kuraPayload);
        }
    }

    @Override
    public Class<KuraRequestMessage> getClassFrom() {
        return KuraRequestMessage.class;
    }

    @Override
    public Class<MqttMessage> getClassTo() {
        return MqttMessage.class;
    }
}
