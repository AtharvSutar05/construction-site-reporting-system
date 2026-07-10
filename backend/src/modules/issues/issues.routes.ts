import { Router } from "express";
import { validateUUID } from "../../middleware/validateUUID.middleware.js";
import { authorizeCompanyRole } from "../../middleware/role.middleware.js";
import { UserRole } from "../../shared/enums/role.enum.js";
import { validateSchema } from "../../middleware/validate_schema.middleware.js";
import { issuesController } from "./issues.controller.js";
import { updateIssueSchema } from "./issues.validation.js";

export const issuesRouter = Router();

issuesRouter.patch(
    "/:issueId",
    validateUUID("issueId"),
    authorizeCompanyRole(UserRole.ENGINEER),
    validateSchema(updateIssueSchema),
    issuesController.updateIssue
);

issuesRouter.delete(
    "/:issueId",
    validateUUID("issueId"),
    authorizeCompanyRole(UserRole.ENGINEER),
    issuesController.deleteIssue
);
