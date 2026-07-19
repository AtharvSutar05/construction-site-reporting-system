import type { Request, Response, NextFunction } from "express";
import { reportApprovalService } from "./report_approval.service.js";

class ReportApprovalController {

    reviewReport = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;
            const reportId = req.params.reportId as string;

            const result = await reportApprovalService.reviewReport(
                reportId,
                memberId,
                companyId,
                req.body
            );

            return res.status(200)
                .json({
                    success: true,
                    message: result.message
                });
        } catch (error) {
            next(error);
        }
    }
}

export const reportApprovalController = new ReportApprovalController();
