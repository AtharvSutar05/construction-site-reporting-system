import "express";
import type { UserRole } from "../../enums/role.enum.ts";

declare global {
  namespace Express {
    interface Request {
      user?: {
        userId: string
      };
      membership?: {
        memberId: string;
        companyId: string;
        role: UserRole;
        joinedAt: Date;
      }
      validatedQuery?: unknown;
    }
  }
}

export {};