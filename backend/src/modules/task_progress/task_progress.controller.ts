import type { Request, Response, NextFunction } from "express";
import { taskProgressService } from "./task_progress.service.js";

class TaskProgressController {
    createTaskProgress = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;
            const reportId = req.params.reportId as string;

            const data = await taskProgressService.createTaskProgress(
                reportId,
                memberId,
                companyId,
                req.body
            );

            return res.status(201)
                .json({
                    success: true,
                    message: "Task progress created successfully",
                    data
                });
        } catch (error) {
            next(error);
        }
    }

    getReportTaskProgress = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { companyId } = req.membership!;
            const reportId = req.params.reportId as string;

            const data = await taskProgressService.getReportTaskProgress(
                reportId,
                companyId
            );

            return res.status(200)
                .json({
                    success: true,
                    data
                });
        } catch (error) {
            next(error);
        }
    }

    updateTaskProgress = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;
            const taskProgressId = req.params.taskProgressId as string;

            const data = await taskProgressService.updateTaskProgress(
                taskProgressId,
                memberId,
                companyId,
                req.body
            );

            return res.status(200)
                .json({
                    success: true,
                    message: "Task progress updated successfully",
                    data
                });
        } catch (error) {
            next(error);
        }
    }

    getExistingReportTaskProgress = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;
            const reportId = req.params.reportId as string;

            const data = await taskProgressService.getExistingReportTaskProgress(
                reportId,
                memberId,
                companyId
            );

            return res.status(200)
                .json({
                    success: true,
                    data
                });
        } catch (error) {
            next(error);
        }
    }
}

export const taskProgressController = new TaskProgressController();
