/*******************************************************************************
 * Copyright (c) 2018 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.service.user;

import org.eclipse.kapua.model.KapuaNamedEntityPredicates;

public interface UserPredicates extends KapuaNamedEntityPredicates {

    String STATUS = "status";
    String EXPIRATIN_DATE = "expirationDate";
    String PHONE_NUMBER = "phoneNumber";
    String EMAIL = "email";
    String DISPLAY_NAME= "displayName";
}
