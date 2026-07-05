import { db } from "../../config/db.js";
import { companyMembers } from "../../database/schema/company_members.schema.js";
import { dailyReports } from "../../database/schema/daily_report.schema.js";
import { sites } from "../../database/schema/sites.schema.js";
import { users } from "../../database/schema/users.schema.js";
import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import type { CreateDailyReportInput, UpdateDailyReportInput } from "./daily_report.validation.js";
import { and, eq, ne } from "drizzle-orm";

class DailyReportRepository {
    async createDailyReport (
        memberId: string,
        reportDate: string,
        data: CreateDailyReportInput
    ) {

        const [dailyReport] = await db
            .insert(dailyReports)
            .values({
                ...data,
                createdBy: memberId,
                reportDate: reportDate,
            })
            .returning();

        return dailyReport;
    }

    async findExistingReportId (
        reportId: string,
        memberId: string,
        compnayId: string
    ) {
        const [existingReport] = await db
            .select({
                id: dailyReports.id,
                status: dailyReports.status
            })
            .from(dailyReports)
            .innerJoin(
                sites,
                eq(dailyReports.siteId, sites.id)
            )
            .where(
                and(
                    eq(dailyReports.id, reportId),
                    eq(dailyReports.createdBy, memberId),
                    eq(sites.companyId, compnayId)
                )
            );

        return existingReport;
    }

    async findTodayReportId (
        reportDate: string,
        siteId: string,
        memberId: string,
        companyId: string
    ) {
        const [existingReport] = await db
            .select({id: dailyReports.id})
            .from(dailyReports)
            .innerJoin(
                sites,
                eq(dailyReports.siteId, sites.id)
            )
            .where(
                and(
                    eq(dailyReports.createdBy, memberId),
                    eq(dailyReports.siteId, siteId),
                    eq(dailyReports.reportDate, reportDate),
                    eq(sites.companyId, companyId)
                )
            );
            
        return existingReport;
    }

    // all can see today's reports (except draft reports)
    async findTodayReports (
        reportDate: string,
        siteId: string,
        companyId: string
    ) {
        const todayReports = await db
            .select({
                id: dailyReports.id,
                engineerName: users.name,
                status: dailyReports.status,
                submittedAt: dailyReports.submittedAt
            })
            .from(dailyReports)
            .innerJoin(
                companyMembers,
                eq(dailyReports.createdBy, companyMembers.id),
            )
            .innerJoin(
                users,
                eq(companyMembers.userId, users.id)
            )
            .innerJoin(
                sites,
                eq(dailyReports.siteId, sites.id)
            )
            .where(
                and(
                    eq(dailyReports.siteId, siteId),
                    eq(dailyReports.reportDate, reportDate),
                    ne(dailyReports.status, ReportStatus.DRAFT),
                    eq(sites.companyId, companyId)
                )
            );
            
        return todayReports;
    }

    // find today's own report
    async findTodayOwnReport (
        reportDate: string,
        memberId: string,
        siteId: string,
        companyId: string
    ) {
        const [todayReport] = await db
            .select({
                id: dailyReports.id,
                reportDate: dailyReports.reportDate,
                weather: dailyReports.weather,
                manpower: dailyReports.manpower,
                remarks: dailyReports.remarks,
                status: dailyReports.status,
                submittedAt: dailyReports.submittedAt,
                createdAt: dailyReports.createdAt,
                updatedAt: dailyReports.updatedAt
            })
            .from(dailyReports)
            .innerJoin(
                sites,
                eq(dailyReports.siteId, sites.id)
            )
            .where(
                and(
                    eq(dailyReports.siteId, siteId),
                    eq(dailyReports.createdBy, memberId),
                    eq(sites.companyId, companyId),
                    eq(dailyReports.reportDate, reportDate)
                )
            );

        return todayReport;
    }

    async updateDailyReport (
        reportId: string,
        data: UpdateDailyReportInput
    ) {
        const [updatedReport] = await db
            .update(dailyReports)
            .set({
                ...data
            })
            .where(eq(dailyReports.id, reportId))
            .returning();

        return updatedReport;
    }

    async submitDailyReport (
        reportId: string
    ) {
        const [submittedReport] = await db
            .update(dailyReports)
            .set({
                status: ReportStatus.SUBMITTED,
                submittedAt: new Date(),
                updatedAt: new Date()
            })
            .where(eq(dailyReports.id, reportId))
            .returning();

        return submittedReport;
    }
}

export const dailyReportRepository = new DailyReportRepository();