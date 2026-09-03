import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { SuggestedTaskStatus } from "../../shared/enums/suggested_task_status.enum.js";
import { ConflictError, NotFoundError } from "../../shared/errors/index.js";
import type { GetSiteReportsQueryInput } from "../../shared/types/queries.js";
import { siteRepository } from "../site/site.repository.js";
import { siteAssignmentRepository } from "../site_assignment/site_assignment.repository.js";
import { taskProgressRepository } from "../task_progress/task_progress.repository.js";
import { dailyReportRepository } from "./daily_report.repository.js";
import type { CreateDailyReportInput, UpdateDailyReportInput } from "./daily_report.validation.js";

class DailyReportService {

    private async ensureDailyReportExist(
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
            throw new NotFoundError("Report not found");
        }

        return existingReport;
    }


    private validateTaskProgressForSubmission(
        taskProgressList: any[]
    ): string[] {
        const errors: string[] = [];

        for (const taskProgress of taskProgressList) {
            if (
                taskProgress.suggestedStatus === SuggestedTaskStatus.COMPLETED &&
                taskProgress.photoCount === 0
            ) {
                errors.push(
                    `${taskProgress.taskTitle}: At least one proof photo is required.`
                );
            }
            if (
                taskProgress.suggestedStatus === SuggestedTaskStatus.IN_PROGRESS &&
                taskProgress.photoCount === 0
            ) {
                errors.push(
                    `${taskProgress.taskTitle}: At least one proof photo is required.`
                );
            }
            if (
                taskProgress.suggestedStatus === SuggestedTaskStatus.PENDING &&
                !taskProgress.hasIssue
            ) {
                errors.push(
                    `${taskProgress.taskTitle}: An issue is required.`
                );
            }
        }

        return errors;
    }

    async createDailyReport(
        memberId: string,
        companyId: string,
        data: CreateDailyReportInput
    ) {
        const now = new Date();
        const reportDate = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;

        const existingSite = await siteRepository.findSiteId(
            data.siteId,
            companyId
        );

        if (!existingSite) {
            throw new NotFoundError("Site not found");
        }

        const existingSiteAssignment = await siteAssignmentRepository.findMemberSiteAssignment(
            memberId,
            data.siteId,
            companyId
        );

        if (!existingSiteAssignment) {
            throw new NotFoundError("Site assignment not found");
        }

        const existingReport = await dailyReportRepository.findTodayReportId(
            reportDate,
            data.siteId,
            memberId,
            companyId
        );

        if (existingReport) {
            throw new ConflictError("Report already created");
        }

        const report = await dailyReportRepository.createDailyReport(
            memberId,
            reportDate,
            data
        );

        return report;
    }

    async getTodayReports(
        siteId: string,
        companyId: string
    ) {
        const now = new Date();
        const reportDate = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;

        const existingSite = await siteRepository.findSiteId(
            siteId,
            companyId,
        );

        if (!existingSite) {
            throw new NotFoundError("Site not found");
        }

        const dailyReport = await dailyReportRepository.findTodayReports(
            reportDate,
            siteId,
            companyId
        );

        return dailyReport;
    }

    async getTodayOwnReport(
        memberId: string,
        siteId: string,
        companyId: string
    ) {
        const now = new Date();
        const reportDate = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;

        const existingSite = await siteRepository.findSiteId(
            siteId,
            companyId
        );

        if (!existingSite) {
            throw new NotFoundError("Site not found");
        }

        const existingSiteAssignment = await siteAssignmentRepository.findMemberSiteAssignment(
            memberId,
            siteId,
            companyId
        );

        if (!existingSiteAssignment) {
            throw new NotFoundError("Site assignment not found");
        }

        const todayReport = await dailyReportRepository.findTodayOwnReport(
            reportDate,
            memberId,
            siteId,
            companyId
        );

        if (!todayReport) {
            throw new NotFoundError("Today's report not found");
        }

        return todayReport;
    }

    async updateDailyReport(
        reportId: string,
        memberId: string,
        companyId: string,
        data: UpdateDailyReportInput
    ) {
        const existingReport = await this.ensureDailyReportExist(
            reportId,
            memberId,
            companyId
        );

        if (existingReport.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Only draft reports can be updated.");
        }

        return await dailyReportRepository.updateDailyReport(
            reportId,
            data
        );
    }

    async submitDailyReport(
        reportId: string,
        memberId: string,
        companyId: string
    ) {
        const existingReport = await this.ensureDailyReportExist(
            reportId,
            memberId,
            companyId
        );

        if (existingReport.status === ReportStatus.SUBMITTED) {
            throw new ConflictError("Report already submitted.");
        }

        if (existingReport.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Only draft reports can be submitted.")
        }


        const taskProgressList = await taskProgressRepository.findReportTaskProgressForValidation(
            reportId
        );

        if (taskProgressList.length === 0) {
            throw new ConflictError("Add at least one task progress before submitting.");
        }

        const validationErrors = this.validateTaskProgressForSubmission(taskProgressList);

        if (validationErrors.length > 0) {
            throw new ConflictError(
                "Report cannot be submitted:\n\n" +
                validationErrors.map(e => `• ${e}`).join("\n")
            );
        }

        return await dailyReportRepository.submitDailyReport(reportId);
    }

    async getSiteReports(
        siteId: string,
        companyId: string,
        query: GetSiteReportsQueryInput,
    ) {
        const existingSite = await siteRepository.findSiteId(
            siteId,
            companyId
        );

        if (!existingSite) {
            throw new NotFoundError("Site not found");
        }

        return await dailyReportRepository.getSiteReports(siteId, companyId, query);
    }
}

export const dailyReportService = new DailyReportService();