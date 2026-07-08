import { db } from "../../config/db.js";
import { taskProgress } from "../../database/schema/task_progress.schema.js";
import { tasks } from "../../database/schema/tasks.schema.js";
import type { CreateTaskProgressInput, UpdateTaskProgressInput } from "./task_progress.validation.js";
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

    async findExistingTaskProgressById(
        taskProgressId: string
    ) {
        const [existingTaskProgress] = await db
            .select({
                id: taskProgress.id,
                reportId: taskProgress.reportId
            })
            .from(taskProgress)
            .where(
                eq(taskProgress.id, taskProgressId)
            );

        return existingTaskProgress;
    }

    async findReportTaskProgress(
        reportId: string
    ) {
        const progressList = await db
            .select({
                id: taskProgress.id,
                taskId: taskProgress.taskId,
                suggestedStatus: taskProgress.suggestedStatus,
                remarks: taskProgress.remarks,
                createdAt: taskProgress.createdAt,
                updatedAt: taskProgress.updatedAt,
                taskTitle: tasks.title,
                taskPriority: tasks.priority
            })
            .from(taskProgress)
            .innerJoin(
                tasks,
                eq(taskProgress.taskId, tasks.id)
            )
            .where(
                eq(taskProgress.reportId, reportId)
            )
            .orderBy(tasks.title);

        return progressList;
    }

    async updateTaskProgress(
        taskProgressId: string,
        data: UpdateTaskProgressInput
    ) {
        const [updatedTaskProgress] = await db
            .update(taskProgress)
            .set({
                ...data,
                updatedAt: new Date()
            })
            .where(eq(taskProgress.id, taskProgressId))
            .returning();

        return updatedTaskProgress;
    }
}

export const taskProgressRepository = new TaskProgressRepository();
