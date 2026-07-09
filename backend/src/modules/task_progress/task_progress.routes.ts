import { Router } from "express";
import { validateUUID } from "../../middleware/validateUUID.middleware.js";
import { authorizeCompanyRole } from "../../middleware/role.middleware.js";
import { UserRole } from "../../shared/enums/role.enum.js";
import { validateSchema } from "../../middleware/validate_schema.middleware.js";
import { taskProgressController } from "./task_progress.controller.js";
import { updateTaskProgressSchema } from "./task_progress.validation.js";
import { upload } from "../../middleware/upload.middleware.js";
import { proofPhotosController } from "../proof_photos/proof_photos.controller.js";
import { uploadProofPhotoSchema } from "../proof_photos/proof_photos.validation.js";

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

taskProgressRouter.post(
    "/:taskProgressId/photos",
    validateUUID("taskProgressId"),
    authorizeCompanyRole(UserRole.ENGINEER),
    upload.single("image"),
    validateSchema(uploadProofPhotoSchema),
    proofPhotosController.uploadProofPhoto
);

taskProgressRouter.get(
    "/:taskProgressId/photos/me",
    validateUUID("taskProgressId"),
    authorizeCompanyRole(UserRole.ENGINEER),
    proofPhotosController.getEngineerProofPhotos
);

taskProgressRouter.get(
    "/:taskProgressId/photos",
    validateUUID("taskProgressId"),
    authorizeCompanyRole(UserRole.ADMIN, UserRole.MANAGER),
    proofPhotosController.getReportProofPhotos
);
