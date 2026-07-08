import { z } from "zod";

export const uploadProofPhotoSchema = z.object({
    caption: z
        .string()
        .max(255, "Caption must be at most 255 characters")
        .optional()
});

export type UploadProofPhotoInput = z.infer<typeof uploadProofPhotoSchema>;
