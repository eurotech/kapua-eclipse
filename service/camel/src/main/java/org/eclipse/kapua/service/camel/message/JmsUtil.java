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
 *     Red Hat Inc
 *******************************************************************************/
package org.eclipse.kapua.service.camel.message;

import org.apache.commons.lang3.StringUtils;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.message.KapuaMessage;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.client.message.MessageConstants;
import org.eclipse.kapua.service.client.message.MessageType;
import org.eclipse.kapua.service.client.protocol.ProtocolDescriptor;
import org.eclipse.kapua.service.device.call.message.DeviceMessage;
import org.eclipse.kapua.translator.Translator;
import org.eclipse.kapua.transport.message.jms.JmsMessage;
import org.eclipse.kapua.transport.message.jms.JmsPayload;
import org.eclipse.kapua.transport.message.jms.JmsTopic;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jms.BytesMessage;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.Queue;
import javax.jms.Topic;

import java.util.Date;

/**
 * Jms message utility class
 *
 * @since 1.0
 */
public class JmsUtil {

    public static final Logger logger = LoggerFactory.getLogger(JmsUtil.class);

    private JmsUtil() {
    }

    /**
     * Convert a {@link BytesMessage} to {@link CamelKapuaMessage}
     *
     * @param jmsMessage
     * @throws JMSException
     * @throws KapuaException
     */
    public static CamelKapuaMessage<?> convertToKapuaMessage(ProtocolDescriptor connectorDescriptor, MessageType messageType, BytesMessage jmsMessage, KapuaId connectionId, String clientId)
            throws JMSException, KapuaException {
        String jmsTopic = jmsMessage.getStringProperty(MessageConstants.PROPERTY_ORIGINAL_TOPIC);
        Date queuedOn = new Date(jmsMessage.getLongProperty(MessageConstants.PROPERTY_ENQUEUED_TIMESTAMP));
        return convertToKapuaMessage(connectorDescriptor, connectorDescriptor.getDeviceClass(messageType), connectorDescriptor.getKapuaClass(messageType), jmsMessage, jmsTopic, queuedOn, connectionId,
                clientId);
    }

    /**
     * Convert a {@link BytesMessage} to {@link KapuaMessage}
     * <p>
     * this code
     * <p>
     * <pre>
     * <code>
     * if (jmsMessage.getBodyLength() > 0) {
     *    payload = new byte[(int) jmsMessage.getBodyLength()];
     *    jmsMessage.readBytes(payload);
     * }
     * </code>
     * </pre>
     * <p>
     * with camel doesn't work.<br>
     * The call getBodyLength returns the correct message size but the read call reads an empty array (-1 is returned).<br>
     * The following code return the payload evaluated.<br>
     * ((ActiveMQMessage)jmsMessage).getContent().data<br>
     * so we modify the method assuming that camel converter called this utility method with a byte[] representing the jms body message.
     *
     * @param jmsMessage
     * @throws JMSException
     * @throws KapuaException
     * @see AbstractKapuaConverter
     */

    // TODO check the code with huge messages
    private static CamelKapuaMessage<?> convertToKapuaMessage(ProtocolDescriptor connectorDescriptor, Class<? extends DeviceMessage<?, ?>> deviceMessageType,
                                                              Class<? extends KapuaMessage<?, ?>> kapuaMessageType, BytesMessage jmsMessage, String jmsTopic,
                                                              Date queuedOn, KapuaId connectionId, String clientId)
            throws JMSException, KapuaException {
        byte[] payload = null;
        // TODO JMS message have no size limits!
        if (jmsMessage.getBodyLength() > 0) {
            payload = new byte[(int) jmsMessage.getBodyLength()];
            int readBytes = jmsMessage.readBytes(payload);
            logger.debug("Message conversion... {} bytes read!", readBytes);
        }
        KapuaMessage<?, ?> kapuaMessage = convertToKapuaMessage(deviceMessageType, kapuaMessageType, payload, jmsTopic, queuedOn, clientId);
        return new CamelKapuaMessage<>(kapuaMessage, connectionId, connectorDescriptor);
    }

    /**
     * Convert raw byte[] message to {@link CamelKapuaMessage}
     *
     * @param connectorDescriptor
     * @param messageType
     * @param messageBody
     * @param jmsTopic
     * @param queuedOn
     * @param connectionId
     * @return
     * @throws KapuaException
     */
    public static CamelKapuaMessage<?> convertToCamelKapuaMessage(ProtocolDescriptor connectorDescriptor, MessageType messageType, byte[] messageBody, String jmsTopic, Date queuedOn,
                                                                  KapuaId connectionId, String clientId)
            throws KapuaException {
        KapuaMessage<?, ?> kapuaMessage = convertToKapuaMessage(connectorDescriptor.getDeviceClass(messageType), connectorDescriptor.getKapuaClass(messageType), messageBody, jmsTopic, queuedOn, clientId);
        return new CamelKapuaMessage<>(kapuaMessage, connectionId, connectorDescriptor);
    }

    /**
     * Convert raw byte[] message to {@link KapuaMessage}
     *
     * @param deviceMessageType
     * @param kapuaMessageType
     * @param messageBody
     * @param jmsTopic
     * @param queuedOn
     * @return
     * @throws KapuaException
     */
    private static KapuaMessage<?, ?> convertToKapuaMessage(Class<? extends DeviceMessage<?, ?>> deviceMessageType, Class<? extends KapuaMessage<?, ?>> kapuaMessageType, byte[] messageBody,
                                                            String jmsTopic, Date queuedOn, String clientId)
            throws KapuaException {
        // first step... from jms to device dependent protocol level (unknown)
        Translator<JmsMessage, DeviceMessage<?, ?>> translatorFromJms = Translator.getTranslatorFor(JmsMessage.class, deviceMessageType);// birth ...
        DeviceMessage<?, ?> deviceMessage = translatorFromJms.translate(new JmsMessage(new JmsTopic(jmsTopic), queuedOn, new JmsPayload(messageBody)));

        // second step.... from device dependent protocol (unknown) to Kapua
        Translator<DeviceMessage<?, ?>, KapuaMessage<?, ?>> translatorToKapua = Translator.getTranslatorFor(deviceMessageType, kapuaMessageType);
        KapuaMessage<?, ?> message = translatorToKapua.translate(deviceMessage);
        if (StringUtils.isEmpty(message.getClientId())) {
            logger.debug("Updating client id since the received value is null (new value {})", clientId);
            message.setClientId(clientId);
        }
        return message;
    }

    public static String getTopic(org.apache.camel.Message message) throws JMSException {
        String topicOrig = message.getHeader(MessageConstants.PROPERTY_ORIGINAL_TOPIC, String.class);
        if (topicOrig != null) {
            return topicOrig;
        } else {
            Destination destination = message.getHeader(MessageConstants.HEADER_CAMEL_JMS_HEADER_DESTINATION, Destination.class);
            if (destination instanceof Queue) {
                topicOrig = ((Queue) destination).getQueueName();
            }
            else if (destination instanceof Topic) {
                topicOrig = ((Topic) destination).getTopicName();
            }
            else {
                logger.warn("jmsMessage destination is null!", destination);
                throw new JMSException(String.format("Unable to extract the destination. Wrong destination %s", destination));
            }
        }
        return topicOrig;
    }

}