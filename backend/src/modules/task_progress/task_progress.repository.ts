import { db } from "../../config/db.js";
import { dailyReports, taskProgress, tasks, proofPhotos, issues } from "../../database/schema/index.js";
import type { CreateTaskProgressInput, UpdateTaskProgressInput } from "./task_progress.validation.js";
import { and, eq, count, sql } from "drizzle-orm";

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

    async findReportTaskProgressForValidation(
        reportId: string,
    ) {
        const taskProgressList = await db
            .select({
                taskProgressId: taskProgress.id,
                taskTitle: tasks.title,
                suggestedStatus: taskProgress.suggestedStatus,

                photoCount: count(proofPhotos.id),

                hasIssue: sql<boolean>`
                COUNT(${issues.id}) > 0
            `,
            })
            .from(dailyReports)
            .innerJoin(
                taskProgress,
                eq(taskProgress.reportId, dailyReports.id)
            )
            .innerJoin(
                tasks,
                eq(taskProgress.taskId, tasks.id)
            )
            .leftJoin(
                proofPhotos,
                eq(proofPhotos.taskProgressId, taskProgress.id)
            )
            .leftJoin(
                issues,
                eq(issues.taskProgressId, taskProgress.id)
            )
            .where(
                eq(dailyReports.id, reportId)
            )
            .groupBy(
                taskProgress.id,
                tasks.title,
                taskProgress.suggestedStatus
            );

        return taskProgressList;
    }

    async findReportTaskProgressForApproval(
        reportId: string,
    ) {
        const progressList = await db
            .select({
                taskId: taskProgress.taskId,
                suggestedStatus: taskProgress.suggestedStatus,
            })
            .from(taskProgress)
            .where(
                eq(taskProgress.reportId, reportId)
            );

        return progressList;
    }
}

export const taskProgressRepository = new TaskProgressRepository();
