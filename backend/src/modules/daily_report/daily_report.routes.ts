import { Router } from "express";
import { authorizeCompanyRole } from "../../middleware/role.middleware.js";
import { UserRole } from "../../shared/enums/role.enum.js";
import { validateSchema } from "../../middleware/validate_schema.middleware.js";
import { createDailyReportSchema, updateDailyReportSchema } from "./daily_report.validation.js";
import { dailyReportController } from "./daily_report.controller.js";
import { validateUUID } from "../../middleware/validateUUID.middleware.js";
import { createTaskProgressSchema } from "../task_progress/task_progress.validation.js";
import { taskProgressController } from "../task_progress/task_progress.controller.js";

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

dailyReportRouter.post(
    "/:reportId/task-progress",
    validateUUID("reportId"),
    authorizeCompanyRole(
        UserRole.ENGINEER
    ),
    validateSchema(createTaskProgressSchema),
    taskProgressController.createTaskProgress
);

dailyReportRouter.get(
    "/:reportId/task-progress",
    validateUUID("reportId"),
    authorizeCompanyRole(
        UserRole.ADMIN,
        UserRole.MANAGER
    ),
    taskProgressController.getReportTaskProgress
);

dailyReportRouter.get(
    "/:reportId/task-progress/me",
    validateUUID("reportId"),
    authorizeCompanyRole(
        UserRole.ENGINEER
    ),
    taskProgressController.getExistingReportTaskProgress
);
