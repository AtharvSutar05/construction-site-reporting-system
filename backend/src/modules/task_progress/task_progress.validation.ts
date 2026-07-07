import { z } from "zod";
import { SuggestedTaskStatus } from "../../shared/enums/suggested_task_status.enum.js";



export const createTaskProgressSchema = z.object({
    taskId: z.uuid(),

    suggestedStatus: z.enum(SuggestedTaskStatus),

    remarks: z
        .string()
        .min(1, "Remarks are required")
        .max(1000, "Remarks must be less than 1000 characters")
        .optional(),
});

export type CreateTaskProgressInput = z.infer<typeof createTaskProgressSchema>; 