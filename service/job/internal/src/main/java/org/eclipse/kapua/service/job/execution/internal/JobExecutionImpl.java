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
package org.eclipse.kapua.service.job.execution.internal;

import org.eclipse.kapua.commons.model.AbstractKapuaUpdatableEntity;
import org.eclipse.kapua.commons.model.id.KapuaEid;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.job.execution.JobExecution;
import org.eclipse.kapua.service.job.execution.JobExecutionStatus;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * {@link JobExecution} implementation
 *
 * @since 1.0.0
 */
@Entity(name = "JobExecution")
@Table(name = "job_job_execution")
public class JobExecutionImpl extends AbstractKapuaUpdatableEntity implements JobExecution {

    private static final long serialVersionUID = -5686107367635300337L;

    @Embedded
    @AttributeOverrides({
            @AttributeOverride(name = "eid", column = @Column(name = "job_id", nullable = false, updatable = false))
    })
    private KapuaEid jobId;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "started_on", nullable = false, updatable = false)
    private Date startedOn;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ended_on", nullable = true, updatable = true)
    private Date endedOn;

    @ElementCollection
    @CollectionTable(name = "job_job_execution_target", joinColumns = @JoinColumn(name = "execution_id", referencedColumnName = "id"))
    @AttributeOverrides({
            @AttributeOverride(name = "eid", column = @Column(name = "target_id", nullable = false, updatable = false))
    })
    private Set<KapuaEid> targetIds;

    @Lob
    @Column(name = "log", nullable = true, updatable = true)
    private String log;

    @Transient
    private JobExecutionStatus status;


    /**
     * Constructor.
     *
     * @since 1.0.0
     */
    public JobExecutionImpl() {
    }

    /**
     * Constructor.
     *
     * @param scopeId The scope {@link KapuaId} to set into the {@link JobExecution}.
     * @since 1.0.0
     */
    public JobExecutionImpl(KapuaId scopeId) {
        super(scopeId);
    }

    /**
     * Clone constructor.
     *
     * @param jobExecution The {@link JobExecution} to clone.
     * @since 1.1.0
     */
    public JobExecutionImpl(JobExecution jobExecution) {
        super(jobExecution);

        setJobId(jobExecution.getJobId());
        setStartedOn(jobExecution.getStartedOn());
        setEndedOn(jobExecution.getEndedOn());
        setTargetIds(jobExecution.getTargetIds());
        setLog(jobExecution.getLog());
    }

    @Override
    public KapuaId getJobId() {
        return jobId;
    }

    @Override
    public void setJobId(KapuaId jobId) {
        this.jobId = KapuaEid.parseKapuaId(jobId);
    }

    @Override
    public Date getStartedOn() {
        return startedOn;
    }

    @Override
    public void setStartedOn(Date startedOn) {
        this.startedOn = startedOn;
    }

    @Override
    public Date getEndedOn() {
        return endedOn;
    }

    @Override
    public void setEndedOn(Date endedOn) {
        this.endedOn = endedOn;
    }


    @Override
    public void setTargetIds(Set<KapuaId> tagIds) {
        this.targetIds = new HashSet<>();

        if (tagIds != null) {
            for (KapuaId id : tagIds) {
                this.targetIds.add(KapuaEid.parseKapuaId(id));
            }
        }
    }

    @Override
    public Set<KapuaId> getTargetIds() {
        Set<KapuaId> tagIds = new HashSet<>();

        if (this.targetIds != null) {
            for (KapuaId deviceTagId : this.targetIds) {
                tagIds.add(new KapuaEid(deviceTagId));
            }
        }

        return tagIds;
    }

    @Override
    public String getLog() {
        return log;
    }

    @Override
    public void setLog(String log) {
        this.log = log;
    }

    @Override
    public JobExecutionStatus getStatus() {
        if (this.getEndedOn() != null) {
            return JobExecutionStatus.TERMINATED;
        } else {
            return JobExecutionStatus.RUNNING;
        }
    }

    @Override
    public void setStatus(JobExecutionStatus status) {
        this.status = status;
    }
}
