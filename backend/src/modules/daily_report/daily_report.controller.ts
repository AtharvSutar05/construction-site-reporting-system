import type { Request, Response, NextFunction } from "express";
import { dailyReportService } from "./daily_report.service.js";
import type { GetSiteReportsQueryInput } from "../../shared/types/queries.js";

class DailyReportController {

    createDailyReport = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;

            const data = await dailyReportService.createDailyReport(
                memberId,
                companyId,
                req.body
            );

            return res.status(201)
                .json({
                    success: true,
                    message: "Daily Report created",
                    data
                });
        } catch (error) {
            next(error);
        }
    }

    getTodayReports = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const siteId = req.params.siteId as string;
            const { companyId } = req.membership!;

            const data = await dailyReportService.getTodayReports(
                siteId,
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

    getTodayOwnReport = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;
            const siteId = req.params.siteId as string;

            const data = await dailyReportService.getTodayOwnReport(
                memberId,
                siteId,
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

    updateDailyReport = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;
            const reportId = req.params.reportId as string;

            const data = await dailyReportService.updateDailyReport(
                reportId,
                memberId,
                companyId,
                req.body
            );

            return res.status(200)
                .json({
                    success: true,
                    message: "Daily Report updated successfully",
                    data
                });
        } catch (error) {
            next(error);
        }
    }


    submitDailyReport = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const { memberId, companyId } = req.membership!;
            const reportId = req.params.reportId as string;

            const data = await dailyReportService.submitDailyReport(
                reportId,
                memberId,
                companyId
            );

            return res.status(200)
                .json({
                    success: true,
                    message: "Daily Report submitted successfully",
                    data
                });
        } catch (error) {
            next(error);
        }
    }

    getSiteReports = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const companyId = req.membership!.companyId;
            const siteId = req.params.siteId as string;
            const query = req.validatedQuery as GetSiteReportsQueryInput;

            const data = await dailyReportService.getSiteReports(siteId, companyId, query);

            return res.json({
                success: true,
                data
            });
        } catch (error) {
            next(error);
        }
    }
}

export const dailyReportController = new DailyReportController();