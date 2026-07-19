import { z } from "zod";
import { ApprovalStatus } from "../../shared/enums/approval_status.enum.js";

export const createReportApprovalSchema = z.object({
    status: z.enum(ApprovalStatus),
    remarks: z
        .string()
        .optional(),
});

export type CreateReportApprovalInput = z.infer<typeof createReportApprovalSchema>;