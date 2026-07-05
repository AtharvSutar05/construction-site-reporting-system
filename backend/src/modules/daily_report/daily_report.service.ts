import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { ConflictError, NotFoundError } from "../../shared/errors/index.js";
import { siteRepository } from "../site/site.repository.js";
import { siteAssignmentRepository } from "../site_assignment/site_assignment.repository.js";
import { dailyReportRepository } from "./daily_report.repository.js";
import type { CreateDailyReportInput, UpdateDailyReportInput } from "./daily_report.validation.js";

class DailyReportService {

    private async ensureDailyReportExist (
        reportId: string,
        memberId: string,
        companyId: string
    ) {
        const existingReport = await dailyReportRepository.findExistingReportId(
            reportId,
            memberId,
            companyId
        );

        if(!existingReport) {
            throw new NotFoundError("Report not found");
        }

        return existingReport;
    }

    async createDailyReport(
        memberId: string,
        companyId: string,
        data: CreateDailyReportInput
    ) {
        const reportDate = new Date().toISOString().slice(0,10);
        const existingSite = await siteRepository.findSiteId(
            data.siteId,
            companyId
        );

        if(!existingSite) {
            throw new NotFoundError("Site not found");
        }

        const existingSiteAssignment = await siteAssignmentRepository.findMemberSiteAssignment(
            memberId,
            data.siteId,
            companyId
        );

        if(!existingSiteAssignment) {
            throw new NotFoundError("Site assignment not found");
        }

        const existingReport = await dailyReportRepository.findTodayReportId(
            reportDate,
            data.siteId,
            memberId,
            companyId
        );

        if(existingReport) {
            throw new ConflictError("Report already created");
        }

        const report = await dailyReportRepository.createDailyReport(
            memberId,
            reportDate,
            data
        );

        return report;
    }

    async getTodayReports (
        siteId: string,
        companyId: string
    ) {
        const reportDate = new Date().toISOString().slice(0,10);
    
        const existingSite = await siteRepository.findSiteId(
            siteId,
            companyId,
        );

        if(!existingSite) {
            throw new NotFoundError("Site not found");
        }
        
        const dailyReport = await dailyReportRepository.findTodayReports(
            reportDate,
            siteId,
            companyId
        );

        if(dailyReport.length === 0) {
            throw new NotFoundError("Today's report not found");
        }

        return dailyReport;
    }

    async getTodayOwnReport (
        memberId: string,
        siteId: string,
        companyId: string
    ) {
        const reportDate = new Date().toISOString().slice(0,10);
        const existingSite = await siteRepository.findSiteId(
            siteId,
            companyId
        );

        if(!existingSite) {
            throw new NotFoundError("Site not found");
        }

        const existingSiteAssignment = await siteAssignmentRepository.findMemberSiteAssignment(
            memberId,
            siteId,
            companyId
        );

        if(!existingSiteAssignment) {
            throw new NotFoundError("Site assignment not found");
        }        

        const todayReport = await dailyReportRepository.findTodayOwnReport(
            reportDate,
            memberId,
            siteId,
            companyId
        );
        
        if(!todayReport) {
            throw new NotFoundError("Today's report not found");
        }

        return todayReport;
    }

    async updateDailyReport (
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

        if(existingReport.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Only draft reports can be updated.");
        }
        
        return await dailyReportRepository.updateDailyReport(
            reportId,
            data
        );
    }

    async submitDailyReport (
        reportId: string,
        memberId: string,
        companyId: string
    ) {
        const existingReport = await this.ensureDailyReportExist(
            reportId,
            memberId,
            companyId
        );

        if(existingReport.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Only draft reports can be submitted.")
        }

        return await dailyReportRepository.submitDailyReport(reportId);
    }
}

export const dailyReportService = new DailyReportService();