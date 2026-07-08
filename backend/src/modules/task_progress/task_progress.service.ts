import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { ConflictError, NotFoundError } from "../../shared/errors/index.js";
import { dailyReportRepository } from "../daily_report/daily_report.repository.js";
import { taskRepository } from "../task/task.repository.js";
import { taskProgressRepository } from "./task_progress.repository.js";
import type { CreateTaskProgressInput, UpdateTaskProgressInput } from "./task_progress.validation.js";

class TaskProgressService {
    //engineer
    async createTaskProgress(
        reportId: string,
        memberId: string,
        companyId: string,
        data: CreateTaskProgressInput
    ) {
        const existingReport = await dailyReportRepository.findExistingReportId(
            reportId,
            memberId,
            companyId
        );

        if (!existingReport) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (existingReport.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Task progress can only be added to DRAFT reports");
        }

        const existingTask = await taskRepository.findTaskByIdAndSite(
            data.taskId,
            existingReport.siteId,
            companyId
        );

        if (!existingTask) {
            throw new NotFoundError("Task not found");
        }

        const existingTaskProgress = await taskProgressRepository.findExistingTaskProgress(
            data.taskId,
            reportId
        );

        if (existingTaskProgress) {
            throw new ConflictError("Task progress already exists for this task");
        }

        const progress = await taskProgressRepository.createTaskProgress(
            reportId,
            data
        );
        return progress;
    }

    // admin + manager
    async getReportTaskProgress(
        reportId: string,
        companyId: string
    ) {
        const existingReport = await dailyReportRepository.findExistingReportIdOnly(
            reportId,
            companyId
        );

        if (!existingReport) {
            throw new NotFoundError("Report not found or access denied");
        }

        const taskProgressList = await taskProgressRepository.findReportTaskProgress(
            reportId
        );

        return taskProgressList;
    }

    // engineer
    async updateTaskProgress(
        taskProgressId: string,
        memberId: string,
        companyId: string,
        data: UpdateTaskProgressInput
    ) {
        const existingTaskProgress = await taskProgressRepository.findExistingTaskProgressById(
            taskProgressId
        );

        if (!existingTaskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const existingReport = await dailyReportRepository.findExistingReportId(
            existingTaskProgress.reportId,
            memberId,
            companyId
        );

        if (!existingReport) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (existingReport.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Task progress can only be updated in DRAFT reports");
        }

        return await taskProgressRepository.updateTaskProgress(
            taskProgressId,
            data
        );
    }

    // engineer
    async getExistingReportTaskProgress(
        reportId: string,
        memberId: string,
        companyId: string
    ) {
        const existingReport = await dailyReportRepository.findExistingReportId(
            reportId,
            memberId,
            companyId
        );

        if (!existingReport) {
            throw new NotFoundError("Report not found or access denied");
        }

        return await taskProgressRepository.findReportTaskProgress(
            reportId
        );
    }
}

export const taskProgressService = new TaskProgressService();
