import { eq } from "drizzle-orm";
import { db } from "../../config/db.js";
import { issues } from "../../database/schema/issues.schema.js";
import type { CreateIssueInput, UpdateIssueInput } from "./issues.validation.js";

class IssuesRepository {
    async createIssue(
        taskProgressId: string,
        data: CreateIssueInput
    ) {
        const [issue] = await db.insert(issues)
            .values({
                taskProgressId,
                ...data
            })
            .returning();

        return issue;
    }

    async findIssueByTaskProgress(taskProgressId: string) {
        const [issue] = await db.select()
            .from(issues)
            .where(eq(issues.taskProgressId, taskProgressId));

        return issue;
    }

    async findIssueById(issueId: string) {
        const [issue] = await db.select({
                id: issues.id,
                taskProgressId: issues.taskProgressId
            })
            .from(issues)
            .where(eq(issues.id, issueId));

        return issue;
    }

    async updateIssue(
        issueId: string,
        data: UpdateIssueInput
    ) {
        const [updatedIssue] = await db.update(issues)
            .set({
                ...data
            })
            .where(eq(issues.id, issueId))
            .returning();

        return updatedIssue;
    }

    async deleteIssue(issueId: string) {
        const [issue] = await db.delete(issues)
            .where(eq(issues.id, issueId))
            .returning();

        return issue;
    }
}

export const issuesRepository = new IssuesRepository();
