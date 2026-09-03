import { z } from "zod";
import { ReportStatus } from "../enums/report_status.enum.js";

export const getSiteReportsQuerySchema = z.object({
    fromDate: z.string().optional(),
    toDate: z.string().optional(),

    status: z.enum([
        ReportStatus.SUBMITTED,
        ReportStatus.APPROVED,
        ReportStatus.REJECTED,
    ]).optional(),

    page: z.coerce.number().int().positive().default(1),

    limit: z.coerce.number().int().positive().max(100).default(20),
});

export type GetSiteReportsQueryInput = z.infer<typeof getSiteReportsQuerySchema>;