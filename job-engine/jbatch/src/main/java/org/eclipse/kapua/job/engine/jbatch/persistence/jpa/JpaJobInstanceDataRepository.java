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
package org.eclipse.kapua.job.engine.jbatch.persistence.jpa;

import org.eclipse.kapua.storage.TxContext;

import java.util.List;

public interface JpaJobInstanceDataRepository {
    JpaJobInstanceData create(TxContext tx, String name, String appTag, String jobXml);

    JpaJobInstanceData find(TxContext tx, long id);

    Integer getJobInstanceCount(TxContext tx, String jobName, String appTag);

    List<Long> getJobInstanceIds(TxContext tx, String jobName, String appTag, Integer offset, Integer limit);

    List<JpaJobInstanceData> getExternalJobInstanceData(TxContext tx);

    int deleteByName(TxContext tx, String jobName);

    /**
     * Deletes {@link JpaJobInstanceData} by its {@link JpaJobInstanceData#getId()}.
     *
     * @param tx The {@link TxContext}
     * @param jobInstanceId The {@link JpaJobInstanceData#getId()} to delete.
     * @since 2.1.0
     */
    int deleteById(TxContext tx, long jobInstanceId);
}
