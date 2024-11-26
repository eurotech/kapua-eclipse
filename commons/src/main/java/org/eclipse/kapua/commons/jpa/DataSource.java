/*******************************************************************************
 * Copyright (c) 2021, 2022 Eurotech and/or its affiliates and others
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
package org.eclipse.kapua.commons.jpa;

import org.eclipse.kapua.KapuaRuntimeException;
import org.eclipse.kapua.commons.setting.system.SystemSetting;
import org.eclipse.kapua.commons.setting.system.SystemSettingKey;

import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class DataSource {

    private static final Logger LOG = LoggerFactory.getLogger(DataSource.class);

    private static HikariDataSource hikariDataSource;

    private DataSource() {
    }

    public static HikariDataSource getDataSource() {
        if (hikariDataSource == null) {
            SystemSetting config = SystemSetting.getInstance();

            hikariDataSource = new HikariDataSource();
            hikariDataSource.setPoolName("hikari-main");
            hikariDataSource.setRegisterMbeans(true);
            hikariDataSource.setAllowPoolSuspension(false);

            // Connection
            hikariDataSource.setDriverClassName(config.getString(SystemSettingKey.DB_JDBC_DRIVER));
            hikariDataSource.setJdbcUrl(JdbcConnectionUrlResolvers.resolveJdbcUrl());
            hikariDataSource.setUsername(config.getString(SystemSettingKey.DB_USERNAME));
            hikariDataSource.setPassword(config.getString(SystemSettingKey.DB_PASSWORD));

            // Pool
            String dbConnectionPoolStrategy = config.getString(SystemSettingKey.DB_POOL_SIZE_STRATEGY, "fixed");

            switch (dbConnectionPoolStrategy) {
                case "fixed": {
                    hikariDataSource.setMaximumPoolSize(config.getInt(SystemSettingKey.DB_POOL_SIZE_FIXED, 5));
                }
                break;
                case "minmax": {
                    LOG.warn("Using deprecated 'minmax' db connection pool sizing strategy. Please consider migrating to 'fixed' strategy");
                    hikariDataSource.setMinimumIdle(config.getInt(SystemSettingKey.DB_POOL_SIZE_MIN, 1));
                    hikariDataSource.setMaximumPoolSize(config.getInt(SystemSettingKey.DB_POOL_SIZE_MAX, 20));
                    hikariDataSource.setIdleTimeout(config.getInt(SystemSettingKey.DB_POOL_IDLE_TIMEOUT, 180000));
                }
                break;
                default: {
                    throw KapuaRuntimeException.internalError("Unrecognized value for setting 'commons.db.pool.size.strategy'. Available values are 'minmax' and 'fixed'. Value provided: '" + dbConnectionPoolStrategy+ "'");
                }
            }

            hikariDataSource.setKeepaliveTime(config.getInt(SystemSettingKey.DB_POOL_KEEPALIVE_TIME, 30000));
            hikariDataSource.setMaxLifetime(config.getInt(SystemSettingKey.DB_POOL_MAX_LIFETIME, 1800000));
            hikariDataSource.setConnectionTestQuery(config.getString(SystemSettingKey.DB_POOL_TEST_QUERY, "SELECT 1"));
            hikariDataSource.setLeakDetectionThreshold(config.getInt(SystemSettingKey.DB_POOL_LEAKDETECTION_THRESHOLD, 0));
        }

        return hikariDataSource;
    }

    @Override
    public String toString() {
        return hikariDataSource.getDriverClassName() + "@" + hikariDataSource.toString();
    }
}
