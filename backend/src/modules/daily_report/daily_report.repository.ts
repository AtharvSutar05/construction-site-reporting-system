import { db } from "../../config/db.js";
import { companyMembers } from "../../database/schema/company_members.schema.js";
import { dailyReports } from "../../database/schema/daily_report.schema.js";
import { sites } from "../../database/schema/sites.schema.js";
import { users } from "../../database/schema/users.schema.js";
import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import type { GetSiteReportsQueryInput } from "../../shared/types/queries.js";
import type { CreateDailyReportInput, UpdateDailyReportInput } from "./daily_report.validation.js";
import { and, eq, ne, count, gte, lte, desc } from "drizzle-orm";

class DailyReportRepository {
    async createDailyReport(
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

    async findExistingReportId(
        reportId: string,
        memberId: string,
        companyId: string
    ) {
        const [existingReport] = await db
            .select({
                id: dailyReports.id,
                siteId: dailyReports.siteId,
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
                    eq(sites.companyId, companyId)
                )
            );

        return existingReport;
    }

    async findExistingReportIdOnly(
        reportId: string,
        companyId: string
    ) {
        const [report] = await db
            .select({
                id: dailyReports.id,
                siteId: dailyReports.siteId,
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
                    eq(sites.companyId, companyId)
                )
            );
        return report;
    }

    async findTodayReportId(
        reportDate: string,
        siteId: string,
        memberId: string,
        companyId: string
    ) {
        const [existingReport] = await db
            .select({ id: dailyReports.id })
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

    async findTodayReports(
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

    async findTodayOwnReport(
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

    async updateDailyReport(
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

    async submitDailyReport(
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

    async updateReportStatus(
        reportId: string,
        status: ReportStatus
    ) {
        const [updatedReport] = await db
            .update(dailyReports)
            .set({
                status,
                updatedAt: new Date()
            })
            .where(eq(dailyReports.id, reportId))
            .returning();

        return updatedReport;
    }

    async countReportsBySiteId(
        siteId: string
    ): Promise<number> {
        const result = await db
            .select({
                count: count(dailyReports.id),
            })
            .from(dailyReports)
            .where(
                and(
                    eq(dailyReports.siteId, siteId),
                    ne(dailyReports.status, ReportStatus.DRAFT),
                )
            );
        return result[0]?.count ?? 0;
    }

    async getSiteReports(
        siteId: string,
        companyId: string,
        query: GetSiteReportsQueryInput,
    ) {
        
        const {
            status,
            fromDate,
            toDate,
            page = 1,
            limit = 20,
        } = query;

    

        const conditions = [
            eq(dailyReports.siteId, siteId),
            eq(sites.companyId, companyId),
            ne(dailyReports.status, ReportStatus.DRAFT),
        ];

        if (status) {
            conditions.push(eq(dailyReports.status, status));
        }

        if (fromDate) {
            conditions.push(
                gte(dailyReports.reportDate, fromDate)
            );
        }

        if (toDate) {
            conditions.push(
                lte(dailyReports.reportDate, toDate)
            );
        }

        const offset = (page - 1) * limit;

        const result = await db
            .select({
                id: dailyReports.id,
                creatorName: users.name,
                reportDate: dailyReports.reportDate,
                status: dailyReports.status,
                submittedAt: dailyReports.submittedAt
            })
            .from(dailyReports)
            .innerJoin(
                companyMembers,
                eq(dailyReports.createdBy, companyMembers.id)
            )
            .innerJoin(
                users,
                eq(companyMembers.userId, users.id)
            )
            .innerJoin(
                sites,
                eq(dailyReports.siteId, sites.id)
            )
            .where(and(...conditions))
            .orderBy(
                desc(dailyReports.reportDate),
                desc(dailyReports.createdAt),
            )
            .limit(limit + 1)
            .offset(offset);

        const hasNextPage = result.length > limit;

        const reports = result.slice(0, limit);

        return {
            reports,
            pagination: {
                page,
                limit,
                hasNextPage
            }
        };
    }
}

export const dailyReportRepository = new DailyReportRepository();
