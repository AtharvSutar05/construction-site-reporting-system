import { db } from "../../config/db.js";
import { dailyReports } from "../../database/schema/daily_report.schema.js";
import { reportApprovals } from "../../database/schema/report_approval.schema.js";
import { tasks } from "../../database/schema/tasks.schema.js";
import { dailyReportRepository } from "../daily_report/daily_report.repository.js";
import { NotFoundError, BadRequestError, ConflictError } from "../../shared/errors/index.js";
import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { ApprovalStatus } from "../../shared/enums/approval_status.enum.js";
import { reportApprovalRepository } from "./report_approval.repository.js";
import { taskProgressRepository } from "../task_progress/task_progress.repository.js";
import type { CreateReportApprovalInput } from "./report_approval.validation.js";
import { SuggestedTaskStatus } from "../../shared/enums/suggested_task_status.enum.js";
import { TaskStatus } from "../../shared/enums/task_status.enum.js";
import { eq } from "drizzle-orm";

class ReportApprovalService {
    async reviewReport(
        reportId: string,
        memberId: string,
        companyId: string,
        data: CreateReportApprovalInput
    ) {
        // report exist + company validation
        const existingReport = await dailyReportRepository.findExistingReportIdOnly(
            reportId,
            companyId
        );

        if (!existingReport) {
            throw new NotFoundError("Report not found");
        }

        switch (existingReport.status) {
            case ReportStatus.DRAFT:
                throw new BadRequestError(
                    "Draft reports cannot be reviewed. The report must be submitted first."
                );

            case ReportStatus.APPROVED:
                throw new ConflictError(
                    "Report has already been approved."
                );

            case ReportStatus.REJECTED:
                throw new ConflictError(
                    "Report has already been rejected."
                );

            case ReportStatus.SUBMITTED:
                break;

            default:
                throw new ConflictError(
                    "Report is not available for review."
                );
        }

        // remark requirement
        if(
            data.status === ApprovalStatus.REJECTED && 
            (!data.remarks || data.remarks.trim().length === 0)
        ) {
            throw new BadRequestError("Remarks are required when rejecting a report.");
        }

        // BEGIN TRANSACTION
        await db.transaction(async (tx) => {
            // insert approval
            await tx
                .insert(reportApprovals)
                .values({
                    reportId: reportId,
                    reviewedBy: memberId,
                    ...data,
                    reviewedAt: new Date()
                });

            // update report status
            await tx
                .update(dailyReports)
                .set({
                    status: data.status === ApprovalStatus.APPROVED ? ReportStatus.APPROVED : ReportStatus.REJECTED,
                    updatedAt: new Date()
                })
                .where(eq(dailyReports.id, reportId));

            // if APPROVED → load task progress and update each task
            if (data.status === ApprovalStatus.APPROVED) {
                const taskProgressList = await taskProgressRepository.findReportTaskProgressForApproval(
                    reportId
                );

                for (const progress of taskProgressList) {
                    await tx
                        .update(tasks)
                        .set({
                            status: this.mapSuggestedStatusToTaskStatus(progress.suggestedStatus),
                            updatedAt: new Date()
                        })
                        .where(eq(tasks.id, progress.taskId));
                }
            }
        });

        const message = data.status === ApprovalStatus.APPROVED
            ? "Report approved successfully."
            : "Report rejected successfully.";

        return { message };
    }

    private mapSuggestedStatusToTaskStatus(
        status: SuggestedTaskStatus
    ): TaskStatus {
        switch (status) {
            case SuggestedTaskStatus.OPEN:
                return TaskStatus.OPEN;

            case SuggestedTaskStatus.IN_PROGRESS:
                return TaskStatus.IN_PROGRESS;

            case SuggestedTaskStatus.PENDING:
                return TaskStatus.PENDING;

            case SuggestedTaskStatus.COMPLETED:
                return TaskStatus.COMPLETED;
        }
    }
}

export const reportApprovalService = new ReportApprovalService();