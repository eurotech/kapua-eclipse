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

import com.ibm.jbatch.container.impl.PartitionedStepBuilder;
import org.eclipse.kapua.commons.jpa.JpaAwareTxContext;
import org.eclipse.kapua.storage.TxContext;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.List;

public class JpaJobInstanceDataRepositoryImpl implements JpaJobInstanceDataRepository {

    @Override
    public JpaJobInstanceData create(TxContext tx, String name, String appTag, String jobXml) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);

        JpaJobInstanceData jpaJobInstanceData = new JpaJobInstanceData();
        jpaJobInstanceData.setName(name);
        jpaJobInstanceData.setAppTag(appTag);
        jpaJobInstanceData.setJobXml(jobXml);

        em.persist(jpaJobInstanceData);
        em.flush();
        em.refresh(jpaJobInstanceData);

        return jpaJobInstanceData;
    }

    @Override
    public JpaJobInstanceData find(TxContext tx, long id) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        return em.find(JpaJobInstanceData.class, id);
    }

    @Override
    public Integer getJobInstanceCount(TxContext tx, String jobName, String appTag) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);

        TypedQuery<Long> countQuery = appTag != null ?
                em.createNamedQuery("JobInstanceData.countByNameTagApp", Long.class) :
                em.createNamedQuery("JobInstanceData.countByName", Long.class);

        countQuery.setParameter("name", jobName);

        if (appTag != null) {
            countQuery.setParameter("appTag", appTag);
        }

        return countQuery.getSingleResult().intValue();
    }

    @Override
    public List<Long> getJobInstanceIds(TxContext tx, String jobName, String appTag, Integer offset, Integer limit) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);

        TypedQuery<Long> selectQuery = appTag != null ?
                em.createNamedQuery("JobInstanceData.selectIdsByNameTagApp", Long.class) :
                em.createNamedQuery("JobInstanceData.selectIdsByName", Long.class);

        selectQuery.setParameter("name", jobName);

        if (appTag != null) {
            selectQuery.setParameter("appTag", appTag);
        }

        if (offset != null) {
            selectQuery.setFirstResult(offset);
        }
        if (limit != null) {
            selectQuery.setMaxResults(limit);
        }

        return selectQuery.getResultList();
    }

    @Override
    public List<JpaJobInstanceData> getExternalJobInstanceData(TxContext tx) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        final TypedQuery<JpaJobInstanceData> selectQuery = em.createNamedQuery("JobInstanceData.selectByName", JpaJobInstanceData.class);
        selectQuery.setParameter("name", PartitionedStepBuilder.JOB_ID_SEPARATOR + "%");
        final List<JpaJobInstanceData> queryResult = selectQuery.getResultList();
        return queryResult;
    }

    @Override
    public int deleteByName(TxContext tx, String jobName) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);

        TypedQuery<Integer> deleteByNameQuery = em.createNamedQuery("JobInstanceData.deleteByName", Integer.class);
        deleteByNameQuery.setParameter("name", jobName);
        return deleteByNameQuery.executeUpdate();
    }

    @Override
    public int deleteById(TxContext tx, long jobInstanceId) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);

        TypedQuery<Integer> deleteByNameQuery = em.createNamedQuery("JobInstanceData.deleteById", Integer.class);
        deleteByNameQuery.setParameter("id", jobInstanceId);
        return deleteByNameQuery.executeUpdate();
    }
}
