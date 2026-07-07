import { db } from "../../config/db.js";
import { taskProgress } from "../../database/schema/task_progress.schema.js";
import type { CreateTaskProgressInput } from "./task_progress.validation.js";
import { and, eq } from "drizzle-orm";

class TaskProgressRepository {
    async createTaskProgress(
        reportId: string,
        data: CreateTaskProgressInput
    ) {
        const [newTaskProgress] = await db
            .insert(taskProgress)
            .values({
                ...data,
                reportId,
            })
            .returning();

        return newTaskProgress;
    }

    async findExistingTaskProgress(
        taskId: string,
        reportId: string
    ) {
        const [existingTaskProgress] = await db
            .select({ id: taskProgress.id })
            .from(taskProgress)
            .where(
                and(
                    eq(taskProgress.taskId, taskId),
                    eq(taskProgress.reportId, reportId)
                )
            );

        return existingTaskProgress;
    }
}

export const taskProgressRepository = new TaskProgressRepository();
