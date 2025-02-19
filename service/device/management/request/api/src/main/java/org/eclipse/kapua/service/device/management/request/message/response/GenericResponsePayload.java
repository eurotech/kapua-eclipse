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
package org.eclipse.kapua.service.device.management.request.message.response;

import javax.xml.bind.annotation.XmlType;

import org.eclipse.kapua.service.device.management.message.response.KapuaResponsePayload;

/**
 * Generic {@link KapuaResponsePayload} definition.
 *
 * @since 1.0.0
 */
@XmlType
public class GenericResponsePayload extends KapuaResponsePayload {

    private static final long serialVersionUID = -4880445665442303028L;

}
