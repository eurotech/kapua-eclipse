/*******************************************************************************
 * Copyright (c) 2011, 2016 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.StringJoiner;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * The KapuaException class is the superclass of exceptions in Kapua project.<br>
 * It extends the JDK Exception class by requesting its invokers to provide an error code when building its instances.<br>
 * The code is one value of KapuaErrorCode; the code is used to document the possible error conditions generated by the platform as well as to identify the localized
 * exception messages to be reported.<br>
 * Exceptions messages are stored in the KapuaExceptionMessagesBundle Properties Bundle and they are keyed on the exception code.
 * 
 * @since 1.0
 * 
 */
public class KapuaException extends Exception
{
    private static final long   serialVersionUID      = -2911004777156433206L;

    private static final String KAPUA_ERROR_MESSAGES  = "kapua-service-error-messages";
    private static final String KAPUA_GENERIC_MESSAGE = "Error: {0}";

    private static final Logger s_logger              = LoggerFactory.getLogger(KapuaException.class);

    protected KapuaErrorCode    code;
    protected Object[]          args;

    /**
     * Constructor
     */
    @SuppressWarnings("unused")
    private KapuaException()
    {
        super();
    }

    /**
     * Constructor
     * 
     * @param message
     */
    @SuppressWarnings("unused")
    private KapuaException(String message)
    {
        super(message);
    }

    /**
     * Constructor
     * 
     * @param message
     * @param cause
     */
    @SuppressWarnings("unused")
    private KapuaException(String message, Throwable cause)
    {
        super(message, cause);
    }

    /**
     * Constructor
     * 
     * @param t
     */
    @SuppressWarnings("unused")
    private KapuaException(Throwable t)
    {
        super(t);
    }

    /**
     * Builds a new KapuaException instance based on the supplied KapuaErrorCode.
     * 
     * @param code
     */
    public KapuaException(KapuaErrorCode code)
    {
        this.code = code;
    }

    /**
     * Builds a new KapuaException instance based on the supplied KapuaErrorCode
     * and optional arguments for the associated exception message.
     * 
     * @param code
     * @param arguments
     */
    public KapuaException(KapuaErrorCode code, Object... arguments)
    {
        this.code = code;
        this.args = arguments;
    }

    /**
     * Builds a new KapuaException instance based on the supplied KapuaErrorCode,
     * an Throwable cause, and optional arguments for the associated exception message.
     * 
     * @param code
     * @param cause
     * @param arguments
     */
    public KapuaException(KapuaErrorCode code, Throwable cause, Object... arguments)
    {
        super(cause);
        this.code = code;
        this.args = arguments;
    }

    /**
     * Factory method to build an KapuaException with the KapuaErrorCode.INTERNAL_ERROR,
     * an Throwable cause, and optional arguments for the associated exception message.
     * 
     * @param cause
     * @param message
     * @return
     */
    public static KapuaException internalError(Throwable cause, String message)
    {
        return new KapuaException(KapuaErrorCodes.INTERNAL_ERROR, cause, message);
    }

    /**
     * Factory method to build an KapuaException with the KapuaErrorCode.INTERNAL_ERROR,
     * and an Throwable cause.
     * 
     * @param cause
     * @return
     */
    public static KapuaException internalError(Throwable cause)
    {
        String arg = cause.getMessage();
        if (arg == null) {
            arg = cause.getClass().getName();
        }
        return new KapuaException(KapuaErrorCodes.INTERNAL_ERROR, cause, arg);
    }

    /**
     * Factory method to build an KapuaException with the KapuaErrorCode.INTERNAL_ERROR,
     * and optional arguments for the associated exception message.
     * 
     * @param message
     * @return
     */
    public static KapuaException internalError(String message)
    {
        return new KapuaException(KapuaErrorCodes.INTERNAL_ERROR, null, message);
    }

    /**
     * Get the error code
     * 
     * @return
     */
    public KapuaErrorCode getCode()
    {
        return code;
    }

    /**
     * Get error message
     */
    public String getMessage()
    {
        return getLocalizedMessage(Locale.US);
    }

    /**
     * Get localized message
     */
    public String getLocalizedMessage()
    {
        return getLocalizedMessage(Locale.getDefault());
    }

    protected String getKapuaErrorMessagesBundle()
    {
        return KAPUA_ERROR_MESSAGES;
    }

    protected String getLocalizedMessage(Locale locale)
    {
        String pattern = getMessagePattern(locale, code);
        if (pattern != null) {
            return MessageFormat.format(pattern, args);
        }
        else {
            // use the generic message by concatenating all args in one string
            StringJoiner joiner = new StringJoiner(",");
            if (args != null && args.length > 0) {
                for (Object arg : args)
                    joiner.add(arg.toString());
            }
            return MessageFormat.format(KAPUA_GENERIC_MESSAGE, joiner.toString());
        }
    }

    protected String getMessagePattern(Locale locale, KapuaErrorCode code)
    {
        //
        // Load the message pattern from the bundle
        String messagePattern = null;
        ResourceBundle resourceBundle = null;
        try {
            resourceBundle = ResourceBundle.getBundle(getKapuaErrorMessagesBundle(), locale);
            messagePattern = resourceBundle.getString(code.name());
        }
        catch (MissingResourceException mre) {
            // log the failure to load a message bundle
            s_logger.warn("Could not load Exception Messages Bundle for Locale {}", locale);
        }

        return messagePattern;
    }
}
