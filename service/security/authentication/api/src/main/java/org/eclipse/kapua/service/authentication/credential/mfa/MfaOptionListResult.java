/*******************************************************************************
 * Copyright (c) 2020, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.service.authentication.credential.mfa;

import org.eclipse.kapua.model.query.KapuaListResult;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * {@link MfaOption} {@link KapuaListResult} definition.
 *
 * @since 1.3.0
 */
@XmlRootElement(name = "mfaOptionListResult")
@XmlAccessorType(XmlAccessType.PROPERTY)
@XmlType(factoryClass = MfaOptionXmlRegistry.class, factoryMethod = "newMfaOptionListResult")
public interface MfaOptionListResult extends KapuaListResult<MfaOption> {

}
