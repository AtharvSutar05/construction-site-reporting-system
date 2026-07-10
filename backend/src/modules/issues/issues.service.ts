import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { ConflictError, NotFoundError } from "../../shared/errors/index.js";
import { dailyReportRepository } from "../daily_report/daily_report.repository.js";
import { taskProgressRepository } from "../task_progress/task_progress.repository.js";
import { issuesRepository } from "./issues.repository.js";
import type { CreateIssueInput, UpdateIssueInput } from "./issues.validation.js";

class IssuesService {
    async createIssue(
        taskProgressId: string,
        memberId: string,
        companyId: string,
        data: CreateIssueInput
    ) {
        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportId(
            taskProgress.reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (report.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Issues can only be created for DRAFT reports");
        }

        const existingIssue = await issuesRepository.findIssueByTaskProgress(taskProgressId);
        if (existingIssue) {
            throw new ConflictError("An issue already exists for this task progress");
        }

        return await issuesRepository.createIssue(taskProgressId, data);
    }

    async getEngineerIssue(
        taskProgressId: string,
        memberId: string,
        companyId: string
    ) {
        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportId(
            taskProgress.reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        const issue = await issuesRepository.findIssueByTaskProgress(taskProgressId);

        return issue ?? null;
    }

    async getReportIssue(
        taskProgressId: string,
        companyId: string
    ) {
        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportIdOnly(
            taskProgress.reportId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        return await issuesRepository.findIssueByTaskProgress(taskProgressId);
    }

    async updateIssue(
        issueId: string,
        memberId: string,
        companyId: string,
        data: UpdateIssueInput
    ) {
        const issue = await issuesRepository.findIssueById(issueId);
        if (!issue) {
            throw new NotFoundError("Issue not found");
        }

        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(issue.taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportId(
            taskProgress.reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (report.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Issues can only be updated in DRAFT reports");
        }

        return await issuesRepository.updateIssue(issueId, data);
    }

    async deleteIssue(
        issueId: string,
        memberId: string,
        companyId: string
    ) {
        const issue = await issuesRepository.findIssueById(issueId);
        if (!issue) {
            throw new NotFoundError("Issue not found");
        }

        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(issue.taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportId(
            taskProgress.reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (report.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Issues can only be deleted from DRAFT reports");
        }

        return await issuesRepository.deleteIssue(issueId);
    }
}

export const issuesService = new IssuesService();
