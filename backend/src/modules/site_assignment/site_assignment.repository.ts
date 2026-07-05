import { and, eq } from "drizzle-orm";
import { db } from "../../config/db.js";
import { siteAssignments, sites } from "../../database/schema/index.js";

class SiteAssignmentRepository {
    async findMemberSiteAssignment (
        memberId: string,
        siteId: string,
        companyId: string
    ) {
        const [existingSiteAssignment] = await db
            .select({id: siteAssignments.id})
            .from(siteAssignments)
            .innerJoin(
                sites,
                eq(siteAssignments.siteId, sites.id)
            )
            .where(
                and(
                    eq(siteAssignments.companyMemberId, memberId),
                    eq(siteAssignments.siteId, siteId),
                    eq(sites.companyId, companyId)
                )
            )
        return existingSiteAssignment;
    }
}

export const siteAssignmentRepository = new SiteAssignmentRepository();