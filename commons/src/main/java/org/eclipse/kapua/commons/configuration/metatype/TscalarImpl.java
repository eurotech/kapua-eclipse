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
 *
 *******************************************************************************/
//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vhudson-jaxb-ri-2.2-147
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a>
// Any modifications to this file will be lost upon recompilation of the source schema.
// Generated on: 2012.11.25 at 06:05:15 PM CET
//


package org.eclipse.kapua.commons.configuration.metatype;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

import org.eclipse.kapua.model.config.metatype.KapuaTscalar;


/**
 * <p>
 * Java class for Tscalar.
 *
 * <p>
 * The following schema fragment specifies the expected content contained within this class.
 * <p>
 * 
 * <pre>
 * &lt;simpleType name="Tscalar"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="String"/&gt;
 *     &lt;enumeration value="Long"/&gt;
 *     &lt;enumeration value="Double"/&gt;
 *     &lt;enumeration value="Float"/&gt;
 *     &lt;enumeration value="Integer"/&gt;
 *     &lt;enumeration value="Byte"/&gt;
 *     &lt;enumeration value="Char"/&gt;
 *     &lt;enumeration value="Boolean"/&gt;
 *     &lt;enumeration value="Short"/&gt;
 *     &lt;enumeration value="Password"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 * @since 1.0
 */
@XmlEnum
@XmlType(name = "Tscalar")
@XmlRootElement(name = "OCD", namespace = "http://www.osgi.org/xmlns/metatype/v1.2.0")
@XmlAccessorType(XmlAccessType.PROPERTY)
public enum TscalarImpl implements KapuaTscalar {
    @XmlEnumValue("String")
    STRING("String"),
    @XmlEnumValue("Long")
    LONG("Long"),
    @XmlEnumValue("Double")
    DOUBLE("Double"),
    @XmlEnumValue("Float")
    FLOAT("Float"),
    @XmlEnumValue("Integer")
    INTEGER("Integer"),
    @XmlEnumValue("Byte")
    BYTE("Byte"),
    @XmlEnumValue("Char")
    CHAR("Char"),
    @XmlEnumValue("Boolean")
    BOOLEAN("Boolean"),
    @XmlEnumValue("Short")
    SHORT("Short"),
    @XmlEnumValue("Password")
    PASSWORD("Password");
    private final String value;

    /**
     * Constructor
     * 
     * @param v
     */
    TscalarImpl(String v) {
        value = v;
    }

    @Override
    public String value() {
        return value;
    }

    /**
     * Convert a String value to a {@link TscalarImpl}
     * 
     * @param v
     * @return
     */
    public static TscalarImpl fromValue(String v) {
        for (TscalarImpl c: TscalarImpl.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
