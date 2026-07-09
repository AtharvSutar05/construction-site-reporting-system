import type { Request, Response, NextFunction } from "express";
import { proofPhotosService } from "./proof_photos.service.js";
import { BadRequestError } from "../../shared/errors/index.js";

class ProofPhotosController {
    uploadProofPhoto = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const taskProgressId = req.params.taskProgressId as string;
            const { memberId, companyId } = req.membership!;
            const file = req.file;
            const { caption } = req.body;

            if (!file) {
                throw new BadRequestError("Image file is required");
            }

            const photo = await proofPhotosService.uploadProofPhoto(
                taskProgressId,
                memberId,
                companyId,
                file.buffer,
                caption
            );

            res.status(201).json({
                success: true,
                message: "Proof photo uploaded successfully",
                data: photo
            });
        } catch (error) {
            next(error);
        }
    };

    getEngineerProofPhotos = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const taskProgressId = req.params.taskProgressId as string;
            const { memberId, companyId } = req.membership!;

            const photos = await proofPhotosService.getEngineerProofPhotos(
                taskProgressId,
                memberId,
                companyId
            );

            res.status(200).json({
                success: true,
                message: "Proof photos retrieved successfully",
                data: photos
            });
        } catch (error) {
            next(error);
        }
    };

    getReportProofPhotos = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const taskProgressId = req.params.taskProgressId as string;
            const { companyId } = req.membership!;

            const photos = await proofPhotosService.getReportProofPhotos(
                taskProgressId,
                companyId
            );

            res.status(200).json({
                success: true,
                message: "Proof photos retrieved successfully",
                data: photos
            });
        } catch (error) {
            next(error);
        }
    };

    deleteProofPhoto = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const photoId = req.params.photoId as string;
            const { memberId, companyId } = req.membership!;

            await proofPhotosService.deleteProofPhoto(
                photoId,
                memberId,
                companyId
            );

            res.status(200).json({
                success: true,
                message: "Proof photo deleted successfully"
            });
        } catch (error) {
            next(error);
        }
    };
}

export const proofPhotosController = new ProofPhotosController();
