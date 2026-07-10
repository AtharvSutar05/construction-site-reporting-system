import type { Request, Response, NextFunction } from "express";
import { issuesService } from "./issues.service.js";

class IssuesController {
    createIssue = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const taskProgressId = req.params.taskProgressId as string;
            const { memberId, companyId } = req.membership!;

            const issue = await issuesService.createIssue(
                taskProgressId,
                memberId,
                companyId,
                req.body
            );

            return res.status(201).json({
                success: true,
                message: "Issue created successfully",
                data: issue
            });
        } catch (error) {
            next(error);
        }
    };

    getEngineerIssue = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const taskProgressId = req.params.taskProgressId as string;
            const { memberId, companyId } = req.membership!;

            const issue = await issuesService.getEngineerIssue(
                taskProgressId,
                memberId,
                companyId
            );

            return res.status(200).json({
                success: true,
                data: issue
            });
        } catch (error) {
            next(error);
        }
    };

    getReportIssue = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const taskProgressId = req.params.taskProgressId as string;
            const { companyId } = req.membership!;

            const issue = await issuesService.getReportIssue(
                taskProgressId,
                companyId
            );

            return res.status(200).json({
                success: true,
                data: issue
            });
        } catch (error) {
            next(error);
        }
    };

    updateIssue = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const issueId = req.params.issueId as string;
            const { memberId, companyId } = req.membership!;

            const issue = await issuesService.updateIssue(
                issueId,
                memberId,
                companyId,
                req.body
            );

            return res.status(200).json({
                success: true,
                message: "Issue updated successfully",
                data: issue
            });
        } catch (error) {
            next(error);
        }
    };

    deleteIssue = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const issueId = req.params.issueId as string;
            const { memberId, companyId } = req.membership!;

            await issuesService.deleteIssue(
                issueId,
                memberId,
                companyId
            );

            res.status(200).json({
                success: true,
                message: "Issue deleted successfully"
            });
        } catch (error) {
            next(error);
        }
    };
}

export const issuesController = new IssuesController();
