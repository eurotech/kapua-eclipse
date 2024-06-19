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
package org.eclipse.kapua.commons.jersey.rest.model;

import org.eclipse.kapua.KapuaIllegalArgumentException;
import org.eclipse.kapua.model.type.ObjectTypeConverter;

import com.google.common.base.Strings;

public class MetricType<V extends Comparable<V>> {

    private Class<V> type;

    @SuppressWarnings("unchecked")
    public MetricType(String stringMetricType) throws KapuaIllegalArgumentException {
        if (!Strings.isNullOrEmpty(stringMetricType)) {
            try {
                type = (Class<V>) ObjectTypeConverter.fromString(stringMetricType);
            } catch (ClassNotFoundException e) {
                throw new KapuaIllegalArgumentException("type", stringMetricType);
            }
        }
    }

    public Class<V> getType() {
        return type;
    }

}
