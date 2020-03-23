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
package org.eclipse.kapua.service.device.call.kura.model.deploy;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * Kura bundle information.
 *
 * @since 1.0
 *
 */
@XmlRootElement(name = "bundleInfo")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType
public class KuraBundleInfo {

    @XmlElement(name = "name")
    public String name;

    @XmlElement(name = "version")
    public String version;

    /**
     * Get the bundle name
     *
     * @return
     */
    public String getName() {
        return name;
    }

    /**
     * Set the bundle name
     *
     * @param name
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Get the bundle version
     *
     * @return
     */
    public String getVersion() {
        return version;
    }

    /**
     * Set the bundle version
     *
     * @param version
     */
    public void setVersion(String version) {
        this.version = version;
    }
}
