import type { ZodType } from "zod";
import type { Request, Response, NextFunction } from "express";

export const validateQuerySchema =
    <T>(schema: ZodType<T>) => {
        return (
            req: Request,
            res: Response,
            next: NextFunction
        ) => {
            const result = schema.safeParse(req.query);

            if (!result.success) {
                return res.status(400).json({
                    success: false,
                    message: "Invalid query parameters",
                    errors: result.error.flatten().fieldErrors,
                });
            }

            req.validatedQuery = result.data;

            next();
        }
    }