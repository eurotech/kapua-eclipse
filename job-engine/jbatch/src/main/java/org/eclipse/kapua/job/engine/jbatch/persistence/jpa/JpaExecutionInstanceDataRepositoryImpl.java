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

import com.google.common.collect.Sets;
import com.ibm.jbatch.container.exception.PersistenceException;
import org.eclipse.kapua.commons.jpa.JpaAwareTxContext;
import org.eclipse.kapua.storage.TxContext;

import javax.batch.operations.NoSuchJobExecutionException;
import javax.batch.runtime.BatchStatus;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.sql.Timestamp;
import java.util.List;
import java.util.Properties;
import java.util.Set;

public class JpaExecutionInstanceDataRepositoryImpl implements JpaExecutionInstanceDataRepository {

    @Override
    public JpaExecutionInstanceData create(TxContext tx, long jobInstanceId, Properties jobParameters, BatchStatus batchStatus, Timestamp timestamp) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        try {
            JpaExecutionInstanceData jpaExecutionInstanceData = new JpaExecutionInstanceData();
            jpaExecutionInstanceData.setJobInstanceId(jobInstanceId);
            jpaExecutionInstanceData.setCreateTime(timestamp);
            jpaExecutionInstanceData.setUpdateTime(timestamp);
            jpaExecutionInstanceData.setBatchStatus(batchStatus);
            jpaExecutionInstanceData.setParameters(jobParameters);

            em.persist(jpaExecutionInstanceData);
            em.flush();
            em.refresh(jpaExecutionInstanceData);

            return jpaExecutionInstanceData;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public JpaExecutionInstanceData updateBatchStatus(TxContext tx, long jobExecutionId, BatchStatus batchStatus, Timestamp updatedOn) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        try {
            JpaExecutionInstanceData jpaExecutionInstanceData = JpaExecutionInstanceDataRepository.doFind(em, jobExecutionId);

            if (jpaExecutionInstanceData != null) {
                jpaExecutionInstanceData.setBatchStatus(batchStatus);
                jpaExecutionInstanceData.setUpdateTime(updatedOn);

                em.merge(jpaExecutionInstanceData);
                em.flush();
                em.refresh(jpaExecutionInstanceData);
            }

            return jpaExecutionInstanceData;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public JpaExecutionInstanceData updateBatchStatusStarted(TxContext tx, long jobExecutionId, Timestamp startedOn) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        try {
            JpaExecutionInstanceData jpaExecutionInstanceData = JpaExecutionInstanceDataRepository.doFind(em, jobExecutionId);

            if (jpaExecutionInstanceData != null) {
                jpaExecutionInstanceData.setBatchStatus(BatchStatus.STARTED);
                jpaExecutionInstanceData.setStartTime(startedOn);
                jpaExecutionInstanceData.setUpdateTime(startedOn);

                em.merge(jpaExecutionInstanceData);
                em.flush();
                em.refresh(jpaExecutionInstanceData);
            }

            return jpaExecutionInstanceData;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public JpaExecutionInstanceData updateBatchStatusEnded(TxContext tx, long jobExecutionId, BatchStatus batchStatus, String exitStatus, Timestamp endedOn) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        try {
            JpaExecutionInstanceData jpaExecutionInstanceData = JpaExecutionInstanceDataRepository.doFind(em, jobExecutionId);

            if (jpaExecutionInstanceData != null) {
                jpaExecutionInstanceData.setBatchStatus(batchStatus);
                jpaExecutionInstanceData.setExitStatus(exitStatus);
                jpaExecutionInstanceData.setEndTime(endedOn);
                jpaExecutionInstanceData.setUpdateTime(endedOn);

                em.merge(jpaExecutionInstanceData);
                em.flush();
                em.refresh(jpaExecutionInstanceData);
            }

            return jpaExecutionInstanceData;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public JpaExecutionInstanceData find(TxContext tx, long jobExecutionId) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        return JpaExecutionInstanceDataRepository.doFind(em, jobExecutionId);
    }

    @Override
    public List<JpaExecutionInstanceData> getJobExecutions(TxContext tx, long jobInstanceId) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        TypedQuery<JpaExecutionInstanceData> selectQuery = em.createNamedQuery("ExecutionInstanceData.getByJobInstance", JpaExecutionInstanceData.class);
        selectQuery.setParameter("jobInstanceId", jobInstanceId);

        return selectQuery.getResultList();
    }

    @Override
    public JpaExecutionInstanceData getMostRecentByJobInstance(TxContext tx, long jobInstanceId) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        TypedQuery<JpaExecutionInstanceData> selectQuery = em.createNamedQuery("ExecutionInstanceData.getByJobInstance", JpaExecutionInstanceData.class);
        selectQuery.setParameter("jobInstanceId", jobInstanceId);

        return selectQuery.getSingleResult();
    }

    @Override
    public Set<Long> getJobRunningExecutions(TxContext tx, String jobName) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        TypedQuery<Long> selectQuery = em.createNamedQuery("ExecutionInstanceData.getRunningByJobName", Long.class);
        selectQuery.setParameter("status1", BatchStatus.STARTED);
        selectQuery.setParameter("status2", BatchStatus.STARTING);
        selectQuery.setParameter("status3", BatchStatus.STOPPING);
        selectQuery.setParameter("jobName", jobName);

        return Sets.newHashSet(selectQuery.getResultList());
    }

    @Override
    public <T> T getJobExecutionField(TxContext tx, long jobExecutionId, JpaExecutionInstanceDataFields field) {
        final EntityManager em = JpaAwareTxContext.extractEntityManager(tx);
        JpaExecutionInstanceData jpaExecutionInstanceData = em.find(JpaExecutionInstanceData.class, jobExecutionId);

        if (jpaExecutionInstanceData == null) {
            throw new NoSuchJobExecutionException("No ExecutionInstanceData found for id: " + jobExecutionId);
        }

        switch (field) {
            case JOB_EXEC_ID:
                return (T) Long.valueOf(jpaExecutionInstanceData.getId());
            case JOB_INSTANCE_ID:
                return (T) Long.valueOf(jpaExecutionInstanceData.getJobInstanceId());
            case CREATE_TIME:
                return (T) jpaExecutionInstanceData.getCreateTime();
            case START_TIME:
                return (T) jpaExecutionInstanceData.getStartTime();
            case UPDATE_TIME:
                return (T) jpaExecutionInstanceData.getUpdateTime();
            case END_TIME:
                return (T) jpaExecutionInstanceData.getEndTime();
            case PARAMETERS:
                return (T) jpaExecutionInstanceData.getParametersAsProperties();
            case BATCH_STATUS:
                return (T) jpaExecutionInstanceData.getBatchStatus();
            case EXIT_STATUS:
                return (T) jpaExecutionInstanceData.getExitStatus();
            default:
                throw new IllegalArgumentException(field.name());
        }
    }
}
