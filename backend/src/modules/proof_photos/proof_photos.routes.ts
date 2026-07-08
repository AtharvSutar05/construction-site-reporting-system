import { Router } from "express";
import { validateUUID } from "../../middleware/validateUUID.middleware.js";
import { authorizeCompanyRole } from "../../middleware/role.middleware.js";
import { UserRole } from "../../shared/enums/role.enum.js";
import { proofPhotosController } from "./proof_photos.controller.js";

export const proofPhotoRouter = Router();

proofPhotoRouter.delete(
    "/:photoId",
    validateUUID("photoId"),
    authorizeCompanyRole(UserRole.ENGINEER),
    proofPhotosController.deleteProofPhoto
);
