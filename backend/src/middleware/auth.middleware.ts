import type { Request, Response, NextFunction } from "express";
import { verifyToken } from "../shared/utils/jwt.util.js";

export const authMiddleware = (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const authCookie = req.cookies?.accessToken;
        const authHeader = req.headers.authorization;
        const accessToken = authCookie ?? authHeader;

        if (!accessToken) {
            return res.status(401).json({
                success: false,
                message: "Access token required",
            });
        }

        let token = accessToken;

        if (accessToken.startsWith("Bearer ")) {
            token = accessToken.split(" ")[1];
            if (!token) {
                return res.status(401).json({
                    success: false,
                    message: "Invalid token format",
                });
            }
        }

        const decoded = verifyToken(token);

        req.user = decoded;

        return next();
    } catch (error) {
        return res.status(401)
            .json({
                success: false,
                message: "Invalid or expired token",
            });
    }
}