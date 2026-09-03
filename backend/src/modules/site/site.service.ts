import type { CreateSiteInput, UpdateSiteInput } from "./site.validation.js";
import { sites, users } from "../../database/schema/index.js";
import { db } from "../../config/db.js";
import { and, eq } from "drizzle-orm";
import { ConflictError } from "../../shared/errors/conflict.error.js";
import { NotFoundError } from "../../shared/errors/not_found.error.js";
import { siteRepository } from "./site.repository.js";
import { dailyReportRepository } from "../daily_report/daily_report.repository.js";
import { taskRepository } from "../task/task.repository.js";
import { siteAssignmentRepository } from "../site_assignment/site_assignment.repository.js";

class SiteService {


    private async checkSiteCode(
        companyId: string,
        siteCode: string,
        excludeSiteId?: string
    ) {
        const [existingSite] = await db
            .select({
                id: sites.id,
            })
            .from(sites)
            .where(
                and(
                    eq(sites.code, siteCode),
                    eq(sites.companyId, companyId)
                )
            );

        if (existingSite && existingSite.id !== excludeSiteId) {
            throw new ConflictError("Site code already exists");
        }
    }

    async getCompanySites(
        companyId: string
    ) {
        return await db
            .select({
                id: sites.id,
                name: sites.name,
                code: sites.code,
                address: sites.address,
                city: sites.city,
                state: sites.state,
                status: sites.status,
                updatedAt: sites.updatedAt
            })
            .from(sites)
            .where(
                eq(sites.companyId, companyId)
            );
    }

    async getCompanySiteById(
        companyId: string,
        siteId: string
    ) {
        const [companySite] = await db
            .select({
                id: sites.id,
                companyId: sites.companyId,
                name: sites.name,
                code: sites.code,
                description: sites.description,
                address: sites.address,
                city: sites.city,
                state: sites.state,
                country: sites.country,
                latitude: sites.latitude,
                longitude: sites.longitude,
                status: sites.status,
                createdBy: users.name,
                createdAt: sites.createdAt,
                updatedAt: sites.updatedAt,
            })
            .from(sites)
            .innerJoin(
                users,
                eq(sites.createdBy, users.id)
            )
            .where(
                and(
                    eq(sites.companyId, companyId),
                    eq(sites.id, siteId)
                )
            );
        if (!companySite) {
            throw new NotFoundError("Site not found");
        }
        return companySite;
    }

    async createSite(
        userId: string,
        companyId: string,
        data: CreateSiteInput
    ) {
        await this.checkSiteCode(
            companyId,
            data.code
        );
        const [site] = await db
            .insert(sites)
            .values({
                ...data,
                companyId,
                createdBy: userId
            })
            .returning();
        if (!site) {
            throw new Error("Failed to create site");
        }
        return site;
    }

    async updateSite(
        companyId: string,
        siteId: string,
        data: UpdateSiteInput
    ) {
        if (data.code) {
            await this.checkSiteCode(
                companyId,
                data.code,
                siteId
            );
        }
        const [updatedSite] = await db
            .update(sites)
            .set({
                ...data,
                updatedAt: new Date()
            })
            .where(
                and(
                    eq(sites.id, siteId),
                    eq(sites.companyId, companyId)
                )
            )
            .returning();

        if (!updatedSite) {
            throw new NotFoundError("Site not found");
        }
        return updatedSite;
    }

    async deleteSite(
        companyId: string,
        siteId: string
    ) {
        const [deletedSite] = await db
            .delete(sites)
            .where(
                and(
                    eq(sites.id, siteId),
                    eq(sites.companyId, companyId)
                )
            )
            .returning();
        if (!deletedSite) {
            throw new NotFoundError("Site not found");
        }
    }

    async getQuickStatsBySiteId(
        siteId: string,
        companyId: string
    ) {
        const existingSite = await siteRepository.findSiteId(siteId, companyId);
        if (!existingSite) {
            throw new NotFoundError("Site not found");
        }
        const [
            totalReports,
            totalTasks,
            totalMembers,
        ] = await Promise.all([
            dailyReportRepository.countReportsBySiteId(siteId),
            taskRepository.countTasksBySiteId(siteId),
            siteAssignmentRepository.countMembersBySiteId(siteId),
        ]);

        return {
            totalReports,
            totalTasks,
            totalMembers,
        };
    }
}

export const siteService = new SiteService();