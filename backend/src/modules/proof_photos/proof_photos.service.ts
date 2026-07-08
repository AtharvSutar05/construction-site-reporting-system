import streamifier from "streamifier";
import { cloudinary } from "../../config/cloudinary.config.js";
import { ReportStatus } from "../../shared/enums/report_status.enum.js";
import { ConflictError, NotFoundError } from "../../shared/errors/index.js";
import { dailyReportRepository } from "../daily_report/daily_report.repository.js";
import { taskProgressRepository } from "../task_progress/task_progress.repository.js";
import { proofPhotosRepository } from "./proof_photos.repository.js";

class ProofPhotosService {
    private uploadToCloudinary(fileBuffer: Buffer): Promise<any> {
        return new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
                { folder: "construction-site/proof_photos" },
                (error, result) => {
                    if (result) resolve(result);
                    else reject(error);
                }
            );
            streamifier.createReadStream(fileBuffer).pipe(uploadStream);
        });
    }

    async uploadProofPhoto(
        taskProgressId: string,
        memberId: string,
        companyId: string,
        fileBuffer: Buffer,
        caption?: string
    ) {
        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportId(
            taskProgress.reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (report.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Photos can only be uploaded to DRAFT reports");
        }

        const uploadResult = await this.uploadToCloudinary(fileBuffer);
        
        return await proofPhotosRepository.createProofPhoto(
            taskProgressId,
            uploadResult.secure_url,
            caption
        );
    }

    async getEngineerProofPhotos(
        taskProgressId: string,
        memberId: string,
        companyId: string
    ) {
        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportId(
            taskProgress.reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        return await proofPhotosRepository.findProofPhotosByTaskProgressId(taskProgressId);
    }

    async getReportProofPhotos(
        taskProgressId: string,
        companyId: string
    ) {
        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        // Using findExistingReportIdOnly for admin/manager who just need to verify it belongs to their company
        const report = await dailyReportRepository.findExistingReportIdOnly(
            taskProgress.reportId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        return await proofPhotosRepository.findProofPhotosByTaskProgressId(taskProgressId);
    }

    async deleteProofPhoto(
        photoId: string,
        memberId: string,
        companyId: string
    ) {
        const photo = await proofPhotosRepository.findProofPhotoById(photoId);
        if (!photo) {
            throw new NotFoundError("Proof photo not found");
        }

        const taskProgress = await taskProgressRepository.findExistingTaskProgressById(photo.taskProgressId);
        if (!taskProgress) {
            throw new NotFoundError("Task progress not found");
        }

        const report = await dailyReportRepository.findExistingReportId(
            taskProgress.reportId,
            memberId,
            companyId
        );

        if (!report) {
            throw new NotFoundError("Report not found or access denied");
        }

        if (report.status !== ReportStatus.DRAFT) {
            throw new ConflictError("Photos can only be deleted from DRAFT reports");
        }

        // Ideally, we could also delete from Cloudinary here to save space, but it's not strictly required in the rules yet.
        // E.g. cloudinary.uploader.destroy(publicId)

        return await proofPhotosRepository.deleteProofPhoto(photoId);
    }
}

export const proofPhotosService = new ProofPhotosService();
