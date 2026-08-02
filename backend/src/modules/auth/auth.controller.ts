import type { Request, Response, NextFunction } from "express";
import { authService } from "./auth.service.js";

class AuthController {

    me = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const data = await authService.getCurrentUser(req.user!.userId);
            return res.status(200)
                .json({
                    success: true,
                    data
                });
        } catch (error) {
            next(error);
        }
    }

    register = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const data = await authService.registerUser(req.body);
            return res.status(201).json({
                success: true,
                message: "User registered successfully",
                data,
            });
        } catch (error) {
            next(error);
        }
    }

    login = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            const data = await authService.loginUser(req.body);

            res.cookie("accessToken", data.token, {
                httpOnly: true,
                secure: process.env.NODE_ENV === "production",
                sameSite: "lax",
                maxAge: 7 * 24 * 60 * 60 * 1000,
            });

            return res.status(200).json({
                success: true,
                message: "User logged in successfully",
                data,
            });
        } catch (error) {
            next(error);
        }
    }

    logOut = async (
        req: Request,
        res: Response,
        next: NextFunction
    ) => {
        try {
            res.clearCookie("accessToken", {
                httpOnly: true,
                secure: process.env.NODE_ENV === "production",
                sameSite: "lax"
            });
            return res.status(200).json({
                success: true,
                message: "User logged out successfully"
            });
        } catch (error) {
            next(error);
        }
    }
}

export const authController = new AuthController();