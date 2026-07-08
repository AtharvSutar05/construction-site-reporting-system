import { Router } from "express";
import { validateUUID } from "../../middleware/validateUUID.middleware.js";
import { authorizeCompanyRole } from "../../middleware/role.middleware.js";
import { UserRole } from "../../shared/enums/role.enum.js";
import { validateSchema } from "../../middleware/validate_schema.middleware.js";
import { taskProgressController } from "./task_progress.controller.js";
import { updateTaskProgressSchema } from "./task_progress.validation.js";

export const taskProgressRouter = Router();

taskProgressRouter.patch(
    "/:taskProgressId",
    validateUUID("taskProgressId"),
    authorizeCompanyRole(
        UserRole.ENGINEER
    ),
    validateSchema(updateTaskProgressSchema),
    taskProgressController.updateTaskProgress
);
