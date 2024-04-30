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
package org.eclipse.kapua.app.console.module.job.shared.service;

import com.extjs.gxt.ui.client.data.ListLoadResult;
import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import org.eclipse.kapua.app.console.module.api.client.GwtKapuaException;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJobStepDefinition;
import org.eclipse.kapua.app.console.module.job.shared.model.GwtJobStepProperty;

@RemoteServiceRelativePath("jobStepDefinition")
public interface GwtJobStepDefinitionService extends RemoteService {

    ListLoadResult<GwtJobStepDefinition> findAll(String scopeIdString)
            throws GwtKapuaException;

    GwtJobStepDefinition find(String scopeIdString, String jobStepDefinitionId)
            throws GwtKapuaException;

    // Just to make Gwt serialize GwtJobStepProperty
    GwtJobStepProperty trickGwt();
}
