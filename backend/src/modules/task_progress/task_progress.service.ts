import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { ConflictError, NotFoundError } from "../../shared/errors/index.js";
import { dailyReportRepository } from "../daily_report/daily_report.repository.js";
import { taskRepository } from "../task/task.repository.js";
import { taskProgressRepository } from "./task_progress.repository.js";
import type { CreateTaskProgressInput } from "./task_progress.validation.js";

class TaskProgressService {
    async createTaskProgress(
        reportId: string,
        memberId: string,
        companyId: string,
        data: CreateTaskProgressInput
    ) {
        const report = await dailyReportRepository.findExistingReportId(
            reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (report.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Task progress can only be added to DRAFT reports");
        }

        const task = await taskRepository.findTaskByIdAndSite(
            data.taskId,
            report.siteId,
            companyId
        );

        if (!task) {
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
}

export const taskProgressService = new TaskProgressService();
