import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { ConflictError, NotFoundError } from "../../shared/errors/index.js";
import { dailyReportRepository } from "../daily_report/daily_report.repository.js";
import { taskRepository } from "../task/task.repository.js";
import { taskProgressRepository } from "./task_progress.repository.js";
import type { CreateTaskProgressInput, UpdateTaskProgressInput } from "./task_progress.validation.js";

class TaskProgressService {
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
}

export const taskProgressService = new TaskProgressService();
