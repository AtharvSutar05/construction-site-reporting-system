import { db } from "../../config/db.js";
import { reportApprovals } from "../../database/schema/report_approval.schema.js";
import type { CreateReportApprovalInput } from "./report_approval.validation.js";
import { eq } from "drizzle-orm";

class ReportApprovalRepository {
    async createReportApproval(
        reportId: string,
        memberId: string,
        data: CreateReportApprovalInput
    ) {
        const [approval] = await db
            .insert(reportApprovals)
            .values({
                reportId: reportId,
                reviewedBy: memberId,
                ...data,
                reviewedAt: new Date()
            })
            .returning();

        return approval;
    }

    async findExistingApprovalId(reportId: string) {
        const [approval] = await db
            .select({ id: reportApprovals.id })
            .from(reportApprovals)
            .where(eq(reportApprovals.reportId, reportId));

        return approval;
    }
}

export const reportApprovalRepository = new ReportApprovalRepository();