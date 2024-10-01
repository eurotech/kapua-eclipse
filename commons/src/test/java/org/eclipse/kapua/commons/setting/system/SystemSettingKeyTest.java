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
package org.eclipse.kapua.commons.setting.system;

import org.eclipse.kapua.qa.markers.junit.JUnitTests;
import org.junit.Assert;
import org.junit.Test;
import org.junit.experimental.categories.Category;

import java.util.EnumMap;
import java.util.Map;


@Category(JUnitTests.class)
public class SystemSettingKeyTest {

    @Test
    public void keyTest() {

        EnumMap<SystemSettingKey, String> systemSettings = new EnumMap<>(SystemSettingKey.class);

        systemSettings.put(SystemSettingKey.SYS_PROVISION_ACCOUNT_NAME, "commons.sys.provision.account.name");
        systemSettings.put(SystemSettingKey.SYS_ADMIN_ACCOUNT, "commons.sys.admin.account");
        systemSettings.put(SystemSettingKey.SYS_ADMIN_USERNAME, "commons.sys.admin.userName");
        systemSettings.put(SystemSettingKey.VERSION, "commons.version");
        systemSettings.put(SystemSettingKey.BUILD_REVISION, "commons.build.revision");
        systemSettings.put(SystemSettingKey.BUILD_TIMESTAMP, "commons.build.timestamp");
        systemSettings.put(SystemSettingKey.BUILD_BRANCH, "commons.build.branch");
        systemSettings.put(SystemSettingKey.BUILD_NUMBER, "commons.build.number");
        systemSettings.put(SystemSettingKey.CHAR_ENCODING, "character.encoding");
        systemSettings.put(SystemSettingKey.DB_JDBC_CONNECTION_URL_RESOLVER, "commons.db.jdbcConnectionUrlResolver");
        systemSettings.put(SystemSettingKey.DB_NAME, "commons.db.name");
        systemSettings.put(SystemSettingKey.DB_USERNAME, "commons.db.username");
        systemSettings.put(SystemSettingKey.DB_PASSWORD, "commons.db.password");
        systemSettings.put(SystemSettingKey.DB_JDBC_DRIVER, "commons.db.jdbc.driver");
        systemSettings.put(SystemSettingKey.DB_CONNECTION_SCHEME, "commons.db.connection.scheme");
        systemSettings.put(SystemSettingKey.DB_CONNECTION_HOST, "commons.db.connection.host");
        systemSettings.put(SystemSettingKey.DB_CONNECTION_PORT, "commons.db.connection.port");
        systemSettings.put(SystemSettingKey.DB_CONNECTION_USE_SSL, "commons.db.connection.useSsl");
        systemSettings.put(SystemSettingKey.DB_CONNECTION_TRUSTSTORE_URL, "commons.db.connection.trust.store.url");
        systemSettings.put(SystemSettingKey.DB_CONNECTION_TRUSTSTORE_PWD, "commons.db.connection.trust.store.pwd");
        systemSettings.put(SystemSettingKey.DB_CONNECTION_ADDITIONAL_OPTIONS, "commons.db.connection.additionalOptions");
        systemSettings.put(SystemSettingKey.DB_SCHEMA, "commons.db.schema");
        systemSettings.put(SystemSettingKey.DB_SCHEMA_ENV, "COMMONS_DB_SCHEMA");
        systemSettings.put(SystemSettingKey.DB_SCHEMA_UPDATE, "commons.db.schema.update");
        systemSettings.put(SystemSettingKey.DB_USE_TIMEZONE, "commons.db.useTimezone");
        systemSettings.put(SystemSettingKey.DB_USE_LEGACY_DATETIME_CODE, "commons.db.useLegacyDatetimeCode");
        systemSettings.put(SystemSettingKey.DB_SERVER_TIMEZONE, "commons.db.serverTimezone");
        systemSettings.put(SystemSettingKey.DB_CHAR_ENCODING, "commons.db.characterEncoding");
        systemSettings.put(SystemSettingKey.DB_POOL_SIZE, "commons.db.pool.size");
        systemSettings.put(SystemSettingKey.DB_POOL_SIZE_MIN, "commons.db.pool.size.min");
        systemSettings.put(SystemSettingKey.DB_POOL_SIZE_MAX, "commons.db.pool.size.max");
        systemSettings.put(SystemSettingKey.DB_POOL_IDLE_TIMEOUT, "commons.db.pool.idle.timeout");
        systemSettings.put(SystemSettingKey.DB_POOL_KEEPALIVE_TIME, "commons.db.pool.keepalive.timeout");
        systemSettings.put(SystemSettingKey.DB_POOL_MAX_LIFETIME, "commons.db.pool.max.lifetime");
        systemSettings.put(SystemSettingKey.DB_POOL_TEST_QUERY, "commons.db.pool.test.query");
        systemSettings.put(SystemSettingKey.DB_POOL_LEAKDETECTION_THRESHOLD, "commons.db.pool.leakdetection.threshold");
        systemSettings.put(SystemSettingKey.DB_CHARACTER_ESCAPE, "commons.db.character.escape");
        systemSettings.put(SystemSettingKey.DB_CHARACTER_WILDCARD_ANY, "commons.db.character.wildcard.any");
        systemSettings.put(SystemSettingKey.DB_CHARACTER_WILDCARD_SINGLE, "commons.db.character.wildcard.single");
        systemSettings.put(SystemSettingKey.BROKER_SCHEME, "broker.scheme");
        systemSettings.put(SystemSettingKey.BROKER_HOST, "broker.host");
        systemSettings.put(SystemSettingKey.METRICS_ENABLE_JMX, "metrics.enable.jmx");
        systemSettings.put(SystemSettingKey.KAPUA_KEY_SIZE, "commons.entity.key.size");
        systemSettings.put(SystemSettingKey.KAPUA_INSERT_MAX_RETRY, "commons.entity.insert.max.retry");
        systemSettings.put(SystemSettingKey.EVENT_BUS_URL, "commons.eventbus.url");
        systemSettings.put(SystemSettingKey.EVENT_BUS_USERNAME, "commons.eventbus.username");
        systemSettings.put(SystemSettingKey.EVENT_BUS_PASSWORD, "commons.eventbus.password");
        systemSettings.put(SystemSettingKey.EVENT_BUS_PRODUCER_POOL_MIN_SIZE, "commons.eventbus.producerPool.minSize");
        systemSettings.put(SystemSettingKey.EVENT_BUS_PRODUCER_POOL_MAX_SIZE, "commons.eventbus.producerPool.maxSize");
        systemSettings.put(SystemSettingKey.EVENT_BUS_PRODUCER_POOL_BORROW_WAIT_MAX, "commons.eventbus.producerPool.maxWaitOnBorrow");
        systemSettings.put(SystemSettingKey.EVENT_BUS_PRODUCER_EVICTION_INTERVAL, "commons.eventbus.producerPool.evictionInterval");
        systemSettings.put(SystemSettingKey.EVENT_BUS_CONSUMER_POOL_SIZE, "commons.eventbus.consumerPool.size");
        systemSettings.put(SystemSettingKey.EVENT_BUS_MESSAGE_SERIALIZER, "commons.eventbus.messageSerializer");
        systemSettings.put(SystemSettingKey.EVENT_BUS_TRANSPORT_USE_EPOLL, "commons.eventbus.transport.useEpoll");
        systemSettings.put(SystemSettingKey.HOUSEKEEPER_EXECUTION_WAIT_TIME, "commons.eventbus.houskeeper.waitTime");
        systemSettings.put(SystemSettingKey.HOUSEKEEPER_EVENT_SCAN_WINDOW, "commons.eventbus.houskeeper.eventScanWindow");
        systemSettings.put(SystemSettingKey.HOUSEKEEPER_OLD_MESSAGES_TIME_WINDOW, "commons.eventbus.houskeeper.oldMessagesTimeWindow");
        systemSettings.put(SystemSettingKey.SETTINGS_HOTSWAP, "commons.settings.hotswap");
        systemSettings.put(SystemSettingKey.CACHING_PROVIDER, "commons.cache.provider.classname");
        systemSettings.put(SystemSettingKey.TMETADATA_LOCAL_CACHE_SIZE_MAXIMUM, "commons.cache.local.tmetadata.maxsize");
        systemSettings.put(SystemSettingKey.CACHE_CONFIG_URL, "commons.cache.config.url");
        systemSettings.put(SystemSettingKey.CACHE_TTL, "commons.cache.config.ttl");
        systemSettings.put(SystemSettingKey.JCACHE_EXPIRY_POLICY, "commons.cache.config.expiryPolicy");

        for (Map.Entry<SystemSettingKey, String> entry : systemSettings.entrySet()) {
            Assert.assertEquals("Expected and actual values should be the same.", entry.getKey().key(), entry.getValue());
        }
    }
}
