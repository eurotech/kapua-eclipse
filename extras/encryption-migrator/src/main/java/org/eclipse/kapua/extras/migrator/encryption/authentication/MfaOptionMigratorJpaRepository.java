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
package org.eclipse.kapua.extras.migrator.encryption.authentication;

import org.eclipse.kapua.commons.jpa.KapuaUpdatableEntityJpaRepository;
import org.eclipse.kapua.service.authentication.credential.mfa.MfaOption;
import org.eclipse.kapua.service.authentication.credential.mfa.MfaOptionListResult;
import org.eclipse.kapua.service.authentication.credential.mfa.MfaOptionRepository;

public class MfaOptionMigratorJpaRepository
        extends KapuaUpdatableEntityJpaRepository<MfaOption, MfaOptionMigrator, MfaOptionListResult>
        implements MfaOptionRepository {
    public MfaOptionMigratorJpaRepository() {
        super(MfaOptionMigrator.class, () -> new MfaOptionMigratorListResultImpl());
    }
}
