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
 *      Eurotech - initial API and implementation
 *      Red Hat Inc
 *******************************************************************************/
package org.eclipse.kapua.service.device.call.kura;

import com.google.common.base.Strings;
import org.checkerframework.checker.nullness.qual.Nullable;
import org.eclipse.kapua.KapuaEntityNotFoundException;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.commons.security.KapuaSecurityUtils;
import org.eclipse.kapua.commons.util.RandomUtils;
import org.eclipse.kapua.message.Message;
import org.eclipse.kapua.service.account.Account;
import org.eclipse.kapua.service.account.AccountService;
import org.eclipse.kapua.service.device.call.DeviceCall;
import org.eclipse.kapua.service.device.call.exception.DeviceCallSendException;
import org.eclipse.kapua.service.device.call.exception.DeviceCallTimeoutException;
import org.eclipse.kapua.service.device.call.kura.exception.KuraDeviceCallErrorCodes;
import org.eclipse.kapua.service.device.call.kura.exception.KuraDeviceCallException;
import org.eclipse.kapua.service.device.call.message.kura.KuraMessage;
import org.eclipse.kapua.service.device.call.message.kura.app.request.KuraRequestChannel;
import org.eclipse.kapua.service.device.call.message.kura.app.request.KuraRequestMessage;
import org.eclipse.kapua.service.device.call.message.kura.app.request.KuraRequestPayload;
import org.eclipse.kapua.service.device.call.message.kura.app.response.KuraResponseMessage;
import org.eclipse.kapua.service.device.registry.Device;
import org.eclipse.kapua.service.device.registry.DeviceRegistryService;
import org.eclipse.kapua.translator.Translator;
import org.eclipse.kapua.translator.TranslatorHub;
import org.eclipse.kapua.translator.exception.TranslatorNotFoundException;
import org.eclipse.kapua.transport.TransportClientFactory;
import org.eclipse.kapua.transport.TransportFacade;
import org.eclipse.kapua.transport.exception.TransportClientGetException;
import org.eclipse.kapua.transport.exception.TransportException;
import org.eclipse.kapua.transport.exception.TransportTimeoutException;
import org.eclipse.kapua.transport.message.TransportMessage;

import javax.inject.Inject;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * {@link DeviceCall} {@link Kura} implementation.
 *
 * @since 1.0.0
 */
public class KuraDeviceCallImpl implements DeviceCall<KuraRequestMessage, KuraResponseMessage> {

    private static final Random RANDOM = RandomUtils.getInstance();
    protected final AccountService accountService;
    protected final DeviceRegistryService deviceRegistryService;
    protected final TransportClientFactory transportClientFactory;
    protected final TranslatorHub translatorHub;

    @Inject
    public KuraDeviceCallImpl(
            AccountService accountService,
            DeviceRegistryService deviceRegistryService,
            TransportClientFactory transportClientFactory, TranslatorHub translatorHub) {
        this.accountService = accountService;
        this.deviceRegistryService = deviceRegistryService;
        this.transportClientFactory = transportClientFactory;
        this.translatorHub = translatorHub;
    }

    @Override
    public KuraResponseMessage create(@NotNull KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage read(@NotNull KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage options(@NotNull KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage delete(@NotNull KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage execute(@NotNull KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage write(@NotNull KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage submit(KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage cancel(KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public KuraResponseMessage send(KuraRequestMessage requestMessage, @Nullable Long timeout)
            throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {
        return sendInternal(requestMessage, timeout);
    }

    @Override
    public Class<KuraMessage> getBaseMessageClass() {
        return KuraMessage.class;
    }
    // Private methods

    /**
     * Sends the {@link KuraRequestMessage} and waits for the response if the {@code timeout} is given.
     *
     * @param requestMessage The {@link KuraRequestMessage} to send.
     * @param timeout        The timeout of waiting the {@link KuraResponseMessage}.
     * @return The {@link KuraResponseMessage} received.
     * @throws DeviceCallTimeoutException if waiting of the response goes on timeout.
     * @throws DeviceCallSendException    if sending the request produces any error.
     * @since 1.0.0
     */
    protected KuraResponseMessage sendInternal(@NotNull KuraRequestMessage requestMessage, @Nullable Long timeout) throws DeviceCallTimeoutException, DeviceCallSendException, TransportException {

        KuraResponseMessage response = null;
        try {
            // Borrow a TransportClient
            try (TransportFacade transportFacade = borrowClient(requestMessage)) {
                // Get Kura to transport translator for the request and vice versa
                Translator<KuraRequestMessage, TransportMessage<?, ?>> translatorKuraTransport = getTranslator(requestMessage.getClass(), transportFacade.getMessageClass());
                Translator<TransportMessage<?, ?>, KuraResponseMessage> translatorTransportKura = getTranslator(transportFacade.getMessageClass(), KuraResponseMessage.class);
                // Make the request
                // Add requestId and requesterClientId to both payload and channel if response is expected
                // Note: Adding to both payload and channel to let the translator choose what to do base on the transport used.
                KuraRequestChannel requestChannel = requestMessage.getChannel();
                KuraRequestPayload requestPayload = requestMessage.getPayload();
                requestPayload.setRequesterClientId(transportFacade.getClientId());

                if (timeout != null) {
                    String requestId = String.valueOf(RANDOM.nextLong());
                    requestChannel.setRequestId(requestId);
                    requestChannel.setRequesterClientId(transportFacade.getClientId());

                    requestPayload.setRequestId(requestId);
                }
                // Do send
                // Set current timestamp
                requestMessage.setTimestamp(new Date());

                // Send
                TransportMessage<?, ?> transportRequestMessage = translatorKuraTransport.translate(requestMessage);
                TransportMessage<?, ?> transportResponseMessage = transportFacade.sendSync(transportRequestMessage, timeout);

                // Translate response
                if (timeout != null) {
                    response = translatorTransportKura.translate(transportResponseMessage);
                }
            }
        } catch (TransportTimeoutException te) {
            throw new DeviceCallTimeoutException(te, timeout);
        } catch (TransportException te) {
            throw te;
        } catch (KapuaException se) {
            throw new DeviceCallSendException(se, requestMessage);
        }

        return response;
    }


    /**
     * Picks a {@link TransportFacade} to send the {@link KuraResponseMessage}.
     *
     * @param kuraRequestMessage The {@link KuraRequestMessage} to send.
     * @return The {@link TransportFacade} to use to send the {@link KuraResponseMessage}.
     * @throws TransportClientGetException If getting the {@link TransportFacade} causes an {@link Exception}.
     * @throws TransportException          For all other errors
     * @since 1.0.0
     */
    protected TransportFacade<?, ?, ?, ?> borrowClient(KuraRequestMessage kuraRequestMessage) throws TransportException {
        String serverIp = null;
        try {
            serverIp = KapuaSecurityUtils.doPrivileged(() -> {
                Account account = accountService.findByName(kuraRequestMessage.getChannel().getScope());

                if (account == null) {
                    throw new KapuaEntityNotFoundException(Account.TYPE, kuraRequestMessage.getChannel().getScope());
                }

                Device device = deviceRegistryService.findByClientId(account.getId(), kuraRequestMessage.getChannel().getClientId());
                if (device == null) {
                    throw new KapuaEntityNotFoundException(Device.TYPE, kuraRequestMessage.getChannel().getClientId());
                }

                return device.getConnection().getServerIp();
            });

            if (Strings.isNullOrEmpty(serverIp)) {
                throw new TransportClientGetException(serverIp);
            }

            Map<String, Object> configParameters = new HashMap<>(1);
            configParameters.put("serverAddress", serverIp);
            return transportClientFactory.getFacade(configParameters);
        } catch (TransportException tce) {
            throw tce;
        } catch (Exception e) {
            throw new TransportClientGetException(e, serverIp);
        }
    }

    /**
     * Gets the translator for the given {@link Message} types.
     *
     * @param from The {@link Message} type from which to translate.
     * @param to   The {@link Message} type to which to translate.
     * @param <F>  The {@link Message} {@code class}from which to translate.
     * @param <T>  The {@link Message} {@code class} to which to translate.
     * @return The {@link Translator} found.
     * @throws KuraDeviceCallException If error occurs while looking for the {@link Translator}.
     * @since 1.0.0
     */
    protected <F extends Message<?, ?>, T extends Message<?, ?>> Translator<F, T> getTranslator(Class<F> from, Class<T> to) throws KuraDeviceCallException {
        Translator<F, T> translator;
        try {
            translator = translatorHub.getTranslatorFor(from, to);
        } catch (TranslatorNotFoundException e) {
            throw new KuraDeviceCallException(KuraDeviceCallErrorCodes.CALL_ERROR, e, from, to);
        }
        return translator;
    }
}
