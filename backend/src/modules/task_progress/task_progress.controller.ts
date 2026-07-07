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
}

export const taskProgressController = new TaskProgressController();
