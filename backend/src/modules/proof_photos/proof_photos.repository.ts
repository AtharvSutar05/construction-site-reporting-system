import { eq } from "drizzle-orm";
import { db } from "../../config/db.js";
import { proofPhotos } from "../../database/schema/proof_photos.schema.js";

class ProofPhotosRepository {
    async createProofPhoto(
        taskProgressId: string,
        imageUrl: string,
        publicId: string,
        caption?: string
    ) {
        const [photo] = await db.insert(proofPhotos)
            .values({
                taskProgressId,
                imageUrl,
                publicId,
                caption
            })
            .returning();

        return photo;
    }

    async findProofPhotosByTaskProgressId(taskProgressId: string) {
        return await db.select()
            .from(proofPhotos)
            .where(eq(proofPhotos.taskProgressId, taskProgressId))
            .orderBy(proofPhotos.createdAt);
    }

    async findProofPhotoById(photoId: string) {
        const [photo] = await db
            .select({
                id: proofPhotos.id,
                taskProgressId: proofPhotos.taskProgressId,
                publicId: proofPhotos.publicId
            })
            .from(proofPhotos)
            .where(eq(proofPhotos.id, photoId));

        return photo;
    }

    async deleteProofPhoto(photoId: string) {
        const [photo] = await db.delete(proofPhotos)
            .where(eq(proofPhotos.id, photoId))
            .returning();

        return photo;
    }
}

export const proofPhotosRepository = new ProofPhotosRepository();
