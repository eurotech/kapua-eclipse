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
package org.eclipse.kapua.job.engine.jbatch.persistence;

import com.ibm.jbatch.container.context.impl.StepContextImpl;
import com.ibm.jbatch.container.exception.PersistenceException;
import com.ibm.jbatch.container.jobinstance.JobInstanceImpl;
import com.ibm.jbatch.container.jobinstance.JobOperatorJobExecution;
import com.ibm.jbatch.container.jobinstance.RuntimeFlowInSplitExecution;
import com.ibm.jbatch.container.jobinstance.RuntimeJobExecution;
import com.ibm.jbatch.container.jobinstance.StepExecutionImpl;
import com.ibm.jbatch.container.persistence.CheckpointData;
import com.ibm.jbatch.container.persistence.CheckpointDataKey;
import com.ibm.jbatch.container.services.IJobExecution;
import com.ibm.jbatch.container.services.IPersistenceManagerService;
import com.ibm.jbatch.container.services.impl.JDBCPersistenceManagerImpl;
import com.ibm.jbatch.container.status.JobStatus;
import com.ibm.jbatch.container.status.StepStatus;
import com.ibm.jbatch.spi.services.IBatchConfig;
import org.eclipse.kapua.KapuaException;
import org.eclipse.kapua.commons.jpa.KapuaJpaTxManagerFactory;
import org.eclipse.kapua.commons.setting.system.SystemSetting;
import org.eclipse.kapua.commons.setting.system.SystemSettingKey;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaCheckpointData;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaCheckpointDataRepository;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaCheckpointDataRepositoryImpl;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaExecutionInstanceData;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaExecutionInstanceDataFields;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaExecutionInstanceDataRepository;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaExecutionInstanceDataRepositoryImpl;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaJobInstanceData;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaJobInstanceDataRepository;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaJobInstanceDataRepositoryImpl;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaJobStatus;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaJobStatusRepository;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaJobStatusRepositoryImpl;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaStepExecutionInstanceData;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaStepExecutionInstanceDataRepository;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaStepExecutionInstanceDataRepositoryImpl;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaStepStatus;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaStepStatusRepository;
import org.eclipse.kapua.job.engine.jbatch.persistence.jpa.JpaStepStatusRepositoryImpl;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.storage.TxManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.batch.operations.NoSuchJobExecutionException;
import javax.batch.runtime.BatchStatus;
import javax.batch.runtime.JobInstance;
import javax.batch.runtime.StepExecution;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * This is a custom implementation of the {@link IPersistenceManagerService} for jBatch which replace the default {@link JDBCPersistenceManagerImpl}.
 * <p>
 * This implementation is much more performant for many reasons, starting from using a DB connection pool and query that are precompiled by JPA using the {@link javax.persistence.NamedQueries}.
 * Entity have been optimized and code now skips some checks that {@link  JDBCPersistenceManagerImpl} performs since those checks are not required by our usage of jBatch.
 * This makes this implementation not compatible with the regular behaviour of the {@link JDBCPersistenceManagerImpl} but makes it fit our needing.
 * <p>
 * As a general overview if the jBatch tables they follow the schema below
 *
 * <pre>
 *     JobInstanceData (aka: JobInstace)
 *     |
 *     |-- has one --- JobStatus
 *     |-- has many -- ExecutionInstanceData (aka: JobExecution)
 *                    |
 *                    |-- has many -- StepExecutionInstanceData (aka: JobStepExecution)
 *                    |              |
 *                    |              |-- has one --- StepStatus
 *                    |
 *                    |-- has many -- CheckpointData
 * </pre>
 *
 * @since 1.2.0
 */
public class JPAPersistenceManagerImpl implements IPersistenceManagerService {

    private static final Logger LOG = LoggerFactory.getLogger(JPAPersistenceManagerImpl.class);
    private final TxManager txManager;
    private final JpaCheckpointDataRepository checkpointDataRepository;
    private final JpaExecutionInstanceDataRepository executionInstanceDataRepository;
    private final JpaJobInstanceDataRepository jobInstanceDataRepository;
    private final JpaStepStatusRepository stepStatusRepository;
    private final JpaStepExecutionInstanceDataRepository stepExecutionInstanceDataRepository;
    private final JpaJobStatusRepository jobStatusRepository;

    //TODO: can these be injected instead?
    public JPAPersistenceManagerImpl() {
        this.txManager = new KapuaJpaTxManagerFactory(SystemSetting.getInstance().getInt(SystemSettingKey.KAPUA_INSERT_MAX_RETRY)).create("jbatch");
        this.checkpointDataRepository = new JpaCheckpointDataRepositoryImpl();
        this.executionInstanceDataRepository = new JpaExecutionInstanceDataRepositoryImpl();
        this.jobInstanceDataRepository = new JpaJobInstanceDataRepositoryImpl();
        this.stepStatusRepository = new JpaStepStatusRepositoryImpl();
        this.stepExecutionInstanceDataRepository = new JpaStepExecutionInstanceDataRepositoryImpl();
        this.jobStatusRepository = new JpaJobStatusRepositoryImpl();
    }

    @Override
    public void init(IBatchConfig batchConfig) {
        LOG.info("jBatch persistence implementation initialized with no actions...");
    }

    @Override
    public void shutdown() {
        LOG.info("jBatch persistence implementation tear down with no actions...");
    }

    // Checkpoint Data
    @Override
    public void createCheckpointData(CheckpointDataKey checkpointDataKey, CheckpointData checkpointData) {
        try {
            txManager.execute(tx -> checkpointDataRepository.create(tx, checkpointDataKey, checkpointData));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public void updateCheckpointData(CheckpointDataKey checkpointDataKey, CheckpointData checkpointData) {
        try {
            txManager.execute(tx -> checkpointDataRepository.update(tx, checkpointDataKey, checkpointData));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public CheckpointData getCheckpointData(CheckpointDataKey checkpointDataKey) {
        try {
            JpaCheckpointData jpaCheckpointData = txManager.execute(tx -> checkpointDataRepository.find(tx, checkpointDataKey));
            return jpaCheckpointData != null ? jpaCheckpointData.toCheckpointData() : null;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    // Job Instance Data
    @Override
    public JobInstance createSubJobInstance(String name, String appTag) {
        return createJobInstance(name, appTag, null);
    }

    @Override
    public JobInstance createJobInstance(String name, String appTag, String jobXml) {
        try {
            JpaJobInstanceData jpaJobInstanceData = txManager.execute(tx -> jobInstanceDataRepository.create(tx, name, appTag, jobXml));
            return jpaJobInstanceData != null ? jpaJobInstanceData.toJobInstance() : null;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public int jobOperatorGetJobInstanceCount(String jobName) {
        return jobOperatorGetJobInstanceCount(jobName, null);
    }

    @Override
    public int jobOperatorGetJobInstanceCount(String jobName, String appTag) {
        try {
            return txManager.execute(tx -> jobInstanceDataRepository.getJobInstanceCount(tx, jobName, appTag));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public List<Long> jobOperatorGetJobInstanceIds(String jobName, int offset, int limit) {
        return jobOperatorGetJobInstanceIds(jobName, null, offset, limit);
    }

    @Override
    public List<Long> jobOperatorGetJobInstanceIds(String jobName, String appTag, int offset, int limit) {
        try {
            return txManager.execute(tx -> jobInstanceDataRepository.getJobInstanceIds(tx, jobName, appTag, offset, limit));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public Map<Long, String> jobOperatorGetExternalJobInstanceData() {
        try {
            final List<JpaJobInstanceData> jpaJobInstanceData = txManager.execute(tx -> jobInstanceDataRepository.getExternalJobInstanceData(tx));
            return jpaJobInstanceData.stream().collect(Collectors.toMap(JpaJobInstanceData::getId, JpaJobInstanceData::getName));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public String getJobCurrentTag(long jobInstanceId) {
        // We are currently not using app tags. They always default to "NOTSET".
        // It, at some point, we want to use them. This code below can be uncommented.
        //        try {
        //            JpaJobInstanceData jobInstanceData = entityManagerSession.onResult(tx -> jobInstanceDataRepository.find(tx, jobInstanceId));
        //            return jobInstanceData != null ? jobInstanceData.getAppTag() : null;
        //        } catch (Exception e) {
        //            throw new PersistenceException(e);
        //        }

        return "NOTSET";
    }

    /**
     * Deletes {@link JpaJobInstanceData} by its {@link JpaJobInstanceData#getId()}.
     *
     * @param jobInstanceId The {@link JpaJobInstanceData#getId()} to delete.
     * @since 2.1.0
     */
    public void deleteJobInstanceData(long jobInstanceId) {
        try {
            txManager.execute(tx -> jobInstanceDataRepository.deleteById(tx, jobInstanceId));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    /**
     * Deletes {@link JobInstance}s by name.
     * <p>
     * This relies on the foreign keys with {@code DELETE CASCADE} on jBatch tables to delete all data from all the other tables.
     * Relationship between those table are summarized in the {@link JPAPersistenceManagerImpl} javadoc.
     *
     * @param jobName The jBatch job name. See {@link org.eclipse.kapua.job.engine.jbatch.driver.JbatchDriver#getJbatchJobName(KapuaId, KapuaId)}
     * @return The number of records delete on the DB.
     * @since 1.2.0
     */
    public int purgeByName(String jobName) {
        try {
            return txManager.execute(tx -> jobInstanceDataRepository.deleteByName(tx, jobName));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }
    // Job Status

    @Override
    public JobStatus createJobStatus(long jobInstanceId) {
        try {
            JpaJobStatus jpaJobStatus = txManager.execute(tx -> jobStatusRepository.create(tx, jobInstanceId));
            return jpaJobStatus != null ? jpaJobStatus.toJobStatus() : null;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public JobStatus getJobStatus(long jobInstanceId) {
        try {
            JpaJobStatus jpaJobStatus = txManager.execute(tx -> jobStatusRepository.find(tx, jobInstanceId));

            JobStatus jobStatus;
            if (jpaJobStatus != null) {
                jobStatus = jpaJobStatus.toJobStatus();
            } else {
                jobStatus = new JobStatus(jobInstanceId);
            }

            if (jobStatus.getJobInstance() == null) {
                JobInstance jobInstance = txManager.execute(tx -> jobInstanceDataRepository.find(tx, jobInstanceId).toJobInstance());

                if (jobInstance == null) {
                    jobInstance = new JobInstanceImpl(jobInstanceId);
                }

                jobStatus.setJobInstance(jobInstance);
            }
            return jobStatus;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public void updateJobStatus(long jobInstanceId, JobStatus jobStatus) {
        try {
            txManager.execute(tx -> jobStatusRepository.update(tx, jobInstanceId, jobStatus));
        } catch (KapuaException e) {
            throw new PersistenceException(e);
        }
    }

    // Execution Instance Data
    @Override
    public RuntimeJobExecution createJobExecution(JobInstance jobInstance, Properties jobParameters, BatchStatus batchStatus) {
        try {
            JpaExecutionInstanceData jpaExecutionInstanceData = txManager.execute(tx -> executionInstanceDataRepository.create(tx, jobInstance.getInstanceId(), jobParameters, batchStatus, new Timestamp(new Date().getTime())));

            RuntimeJobExecution runtimeJobExecution = new RuntimeJobExecution(jobInstance, jpaExecutionInstanceData.getId());
            runtimeJobExecution.setBatchStatus(batchStatus.name());
            runtimeJobExecution.setCreateTime(jpaExecutionInstanceData.getCreateTime());
            runtimeJobExecution.setLastUpdateTime(jpaExecutionInstanceData.getUpdateTime());

            return runtimeJobExecution;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public RuntimeFlowInSplitExecution createFlowInSplitExecution(JobInstance jobInstance, BatchStatus batchStatus) {
        try {
            JpaExecutionInstanceData jpaExecutionInstanceData = txManager.execute(tx -> executionInstanceDataRepository.create(tx, jobInstance.getInstanceId(), null, batchStatus, new Timestamp(new Date().getTime())));

            RuntimeFlowInSplitExecution runtimeFlowInSplitExecution = new RuntimeFlowInSplitExecution(jobInstance, jpaExecutionInstanceData.getId());
            runtimeFlowInSplitExecution.setBatchStatus(batchStatus.name());
            runtimeFlowInSplitExecution.setCreateTime(jpaExecutionInstanceData.getCreateTime());
            runtimeFlowInSplitExecution.setLastUpdateTime(jpaExecutionInstanceData.getUpdateTime());

            return runtimeFlowInSplitExecution;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public Timestamp jobOperatorQueryJobExecutionTimestamp(long jobExecutionId, TimestampType timestampType) {
        try {
            JpaExecutionInstanceDataFields selectField;

            switch (timestampType) {
                case CREATE:
                    selectField = JpaExecutionInstanceDataFields.CREATE_TIME;
                    break;
                case STARTED:
                    selectField = JpaExecutionInstanceDataFields.START_TIME;
                    break;
                case LAST_UPDATED:
                    selectField = JpaExecutionInstanceDataFields.UPDATE_TIME;
                    break;
                case END:
                    selectField = JpaExecutionInstanceDataFields.END_TIME;
                    break;
                default:
                    throw new IllegalArgumentException(timestampType.name());
            }

            return txManager.execute(tx -> executionInstanceDataRepository.getJobExecutionField(tx, jobExecutionId, selectField));
        } catch (NoSuchJobExecutionException nsjee) {
            throw nsjee;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public String jobOperatorQueryJobExecutionBatchStatus(long jobExecutionId) {
        try {
            return txManager.execute(tx -> executionInstanceDataRepository.<BatchStatus>getJobExecutionField(tx, jobExecutionId, JpaExecutionInstanceDataFields.BATCH_STATUS)).name();
        } catch (NoSuchJobExecutionException nsjee) {
            throw nsjee;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public String jobOperatorQueryJobExecutionExitStatus(long key) {
        try {
            return txManager.execute(tx -> executionInstanceDataRepository.getJobExecutionField(tx, key, JpaExecutionInstanceDataFields.EXIT_STATUS));
        } catch (NoSuchJobExecutionException nsjee) {
            throw nsjee;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public long getJobInstanceIdByExecutionId(long executionId) throws NoSuchJobExecutionException {
        return jobOperatorQueryJobExecutionJobInstanceId(executionId);
    }

    @Override
    public long jobOperatorQueryJobExecutionJobInstanceId(long key) throws NoSuchJobExecutionException {
        try {
            Long jobInstanceId = txManager.execute(tx -> executionInstanceDataRepository.getJobExecutionField(tx, key, JpaExecutionInstanceDataFields.JOB_INSTANCE_ID));

            if (jobInstanceId != null) {
                return jobInstanceId;
            } else {
                throw new NoSuchJobExecutionException("Job Instance not found for Job Execution Id: " + key);
            }

        } catch (NoSuchJobExecutionException nsjee) {
            throw nsjee;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public Properties getParameters(long jobExecutionId) throws NoSuchJobExecutionException {
        try {
            Properties jobParameters = txManager.execute(tx -> executionInstanceDataRepository.getJobExecutionField(tx, jobExecutionId, JpaExecutionInstanceDataFields.PARAMETERS));

            if (jobParameters != null) {
                return jobParameters;
            } else {
                throw new NoSuchJobExecutionException("Job Instance not found for Job Execution Id: " + jobExecutionId);
            }
        } catch (NoSuchJobExecutionException nsjee) {
            throw nsjee;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public void updateBatchStatusOnly(long executionInstanceDataId, BatchStatus batchStatus, Timestamp updatedOn) {
        try {
            txManager.execute(tx -> executionInstanceDataRepository.updateBatchStatus(tx, executionInstanceDataId, batchStatus, updatedOn));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public void updateWithFinalExecutionStatusesAndTimestamps(long executionInstanceDataId, BatchStatus batchStatus, String exitStatus, Timestamp endedOn) {
        try {
            txManager.execute(tx -> executionInstanceDataRepository.updateBatchStatusEnded(tx, executionInstanceDataId, batchStatus, exitStatus, endedOn));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public void markJobStarted(long executionInstanceDataId, Timestamp startedOn) {
        try {
            txManager.execute(tx -> executionInstanceDataRepository.updateBatchStatusStarted(tx, executionInstanceDataId, startedOn));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public IJobExecution jobOperatorGetJobExecution(long jobExecutionId) {
        try {
            return txManager.execute(tx -> {
                JpaExecutionInstanceData jpaExecutionInstanceData = executionInstanceDataRepository.find(tx, jobExecutionId);
                JpaJobInstanceData jpaJobInstanceData = jobInstanceDataRepository.find(tx, jpaExecutionInstanceData.getJobInstanceId());

                JobOperatorJobExecution jobExecution = jpaExecutionInstanceData.toJobExecution();
                jobExecution.setJobName(jpaJobInstanceData.getName());

                return jobExecution;
            });
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public List<IJobExecution> jobOperatorGetJobExecutions(long jobInstanceId) {
        try {
            List<JpaExecutionInstanceData> jpaExecutionInstanceDataResult = txManager.execute(tx -> executionInstanceDataRepository.getJobExecutions(tx, jobInstanceId));
            return jpaExecutionInstanceDataResult.stream().map(JpaExecutionInstanceData::toJobExecution).collect(Collectors.toList());
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public Set<Long> jobOperatorGetRunningExecutions(String jobName) {
        try {
            return txManager.execute(tx -> executionInstanceDataRepository.getJobRunningExecutions(tx, jobName));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public JobStatus getJobStatusFromExecution(long jobExecutionId) {
        try {
            return txManager.execute(tx -> {
                JpaExecutionInstanceData jpaExecutionInstanceData = executionInstanceDataRepository.find(tx, jobExecutionId);

                JpaJobStatus jobStatus = jobStatusRepository.find(tx, jpaExecutionInstanceData.getJobInstanceId());

                return jobStatus.getObjAsJobStatus();
            });

        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public String getTagName(long jobExecutionId) {
        try {
            JpaJobInstanceData jpaJobInstanceData = txManager.execute(tx -> {
                JpaExecutionInstanceData jpaExecutionInstanceData = executionInstanceDataRepository.find(tx, jobExecutionId);
                return jobInstanceDataRepository.find(tx, jpaExecutionInstanceData.getJobInstanceId());
            });
            return jpaJobInstanceData.getAppTag();
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public long getMostRecentExecutionId(long jobInstanceId) {
        try {
            JpaExecutionInstanceData jpaExecutionInstanceData = txManager.execute(tx -> executionInstanceDataRepository.getMostRecentByJobInstance(tx, jobInstanceId));
            return jpaExecutionInstanceData.getId();
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    // Step Execution Instance Data
    @Override
    public StepExecutionImpl createStepExecution(long jobExecutionId, StepContextImpl stepContext) {
        try {
            JpaStepExecutionInstanceData jpaStepExecutionInstanceData = txManager.execute(tx -> stepExecutionInstanceDataRepository.insert(tx, jobExecutionId, stepContext));
            return jpaStepExecutionInstanceData != null ? jpaStepExecutionInstanceData.toStepExecution() : null;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public void updateStepExecution(StepContextImpl stepContext) {
        try {
            txManager.execute(tx -> stepExecutionInstanceDataRepository.update(tx, stepContext));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public Map<String, StepExecution> getMostRecentStepExecutionsForJobInstance(long jobInstanceId) {
        try {
            return txManager.execute(tx -> stepExecutionInstanceDataRepository.getExternalJobInstanceData(tx, jobInstanceId));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public List<StepExecution> getStepExecutionsForJobExecution(long jobExecutionId) {
        try {
            return txManager.execute(tx -> stepExecutionInstanceDataRepository.getStepExecutionsByJobExecution(tx, jobExecutionId));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public StepExecution getStepExecutionByStepExecutionId(long stepExecId) {
        try {
            JpaStepExecutionInstanceData jpaStepExecutionInstanceData = txManager.execute(tx -> stepExecutionInstanceDataRepository.find(tx, stepExecId));
            return jpaStepExecutionInstanceData != null ? jpaStepExecutionInstanceData.toStepExecution() : null;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    // Step Status
    @Override
    public StepStatus createStepStatus(long stepExecutionId) {
        try {
            JpaStepStatus jpaStepStatus = txManager.execute(tx -> stepStatusRepository.create(tx, stepExecutionId));
            return jpaStepStatus != null ? jpaStepStatus.toStepStatus() : null;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public StepStatus getStepStatus(long jobInstanceId, String stepName) {
        try {
            JpaStepStatus jpaStepStatus = txManager.execute(tx -> stepStatusRepository.getStepStatusByJobInstance(tx, jobInstanceId, stepName));
            return jpaStepStatus != null ? jpaStepStatus.toStepStatus() : null;
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }

    @Override
    public void updateStepStatus(long stepExecutionId, StepStatus stepStatus) {
        try {
            txManager.execute(tx -> stepStatusRepository.update(tx, stepExecutionId, stepStatus));
        } catch (Exception e) {
            throw new PersistenceException(e);
        }
    }
    // Random

    @Override
    public void purge(String apptag) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void updateWithFinalPartitionAggregateStepExecution(long rootJobExecutionId, StepContextImpl stepContext) {
        throw new UnsupportedOperationException();
    }
}

