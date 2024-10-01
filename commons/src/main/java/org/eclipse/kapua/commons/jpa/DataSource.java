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

import org.eclipse.kapua.commons.setting.system.SystemSetting;
import org.eclipse.kapua.commons.setting.system.SystemSettingKey;

import com.zaxxer.hikari.HikariDataSource;

public final class DataSource {

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
            hikariDataSource.setMaximumPoolSize(config.getInt(SystemSettingKey.DB_POOL_SIZE, 5));
            // Commented out since is not good for performances
            // See official documentation https://github.com/brettwooldridge/HikariCP
            // This property controls the minimum number of idle connections that HikariCP tries to maintain in the pool.
            // If the idle connections dip below this value, HikariCP will make a best effort to add additional connections
            // quickly and efficiently. However, for maximum performance and responsiveness to spike demands, we recommend not
            // setting this value and instead allowing HikariCP to act as a fixed size connection pool.
            //
            // hikariDataSource.setMinimumIdle(config.getInt(SystemSettingKey.DB_POOL_SIZE_MIN, 1));

            // Fixed size so this parameter is ignored by hikari
            // hikariDataSource.setIdleTimeout(config.getInt(SystemSettingKey.DB_POOL_IDLE_TIMEOUT, 180000));
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
