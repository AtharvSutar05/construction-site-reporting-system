import { and, eq, count } from "drizzle-orm";
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

    async countMembersBySiteId(
        siteId: string
    ): Promise<number> {
        const result = await db
            .select({
                count: count()
            })
            .from(siteAssignments)
            .where(
                eq(siteAssignments.siteId, siteId)
            );

        return result[0]?.count ?? 0;
    }
}

export const siteAssignmentRepository = new SiteAssignmentRepository();