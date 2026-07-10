import { z } from "zod";
import { IssueType } from "../../shared/enums/isssue_type.enum.js";

export const createIssueSchema = z.object({
    type: z.enum(IssueType),

    description: z.string()
});

export const updateIssueSchema = z.object({
    type: z.enum(IssueType).optional(),

    description: z.string().optional()
});

export type CreateIssueInput = z.infer<typeof createIssueSchema>;
export type UpdateIssueInput = z.infer<typeof updateIssueSchema>;
