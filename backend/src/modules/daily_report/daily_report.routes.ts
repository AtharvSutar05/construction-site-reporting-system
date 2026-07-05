import { Router } from "express";
import { authorizeCompanyRole } from "../../middleware/role.middleware.js";
import { UserRole } from "../../shared/enums/role.enum.js";
import { validateSchema } from "../../middleware/validate_schema.middleware.js";
import { createDailyReportSchema, updateDailyReportSchema } from "./daily_report.validation.js";
import { dailyReportController } from "./daily_report.controller.js";
import { validateUUID } from "../../middleware/validateUUID.middleware.js";

export const dailyReportRouter = Router();

dailyReportRouter.post(
    "/",
    authorizeCompanyRole(
        UserRole.ENGINEER
    ),
    validateSchema(createDailyReportSchema),
    dailyReportController.createDailyReport
);

dailyReportRouter.patch(
    "/:reportId",
    validateUUID("reportId"),
    authorizeCompanyRole(
        UserRole.ENGINEER
    ),
    validateSchema(updateDailyReportSchema),
    dailyReportController.updateDailyReport
);

dailyReportRouter.patch(
    "/:reportId/submit",
    validateUUID("reportId"),
    authorizeCompanyRole(
        UserRole.ENGINEER
    ),
    dailyReportController.submitDailyReport
);