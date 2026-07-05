import { z } from "zod";

export const createDailyReportSchema = z.object({
    siteId: z.uuid("Invalid site id."),

    weather: z
        .string()
        .trim()
        .min(1, "Weather is required.")
        .max(100, "Weather cannot exceed 100 characters."),

    manpower: z
        .int()
        .min(0, "Manpower cannot be negative."),

    remarks: z
        .string()
        .trim()
        .optional(),
});

export const updateDailyReportSchema = z.object({
    weather: z
        .string()
        .trim()
        .min(1, "Weather is required.")
        .max(100, "Weather cannot exceed 100 characters.")
        .optional(),

    manpower: z
        .int()
        .min(0, "Manpower cannot be negative.")
        .optional(),

    remarks: z
        .string()
        .trim()
        .optional(),
});

export type CreateDailyReportInput = z.infer<typeof createDailyReportSchema>;
export type UpdateDailyReportInput = z.infer<typeof updateDailyReportSchema>;
