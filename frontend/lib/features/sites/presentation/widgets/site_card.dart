import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/sites/data/models/site_model.dart';
import 'package:frontend/features/sites/presentation/widgets/site_status_widget.dart';
import 'package:frontend/shared/widgets/cards/custom_app_card.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SiteCard extends StatelessWidget {
  final SiteModel site;
  const SiteCard({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(
        RouteNames.siteDetail,
        pathParameters: {'siteId': site.id},
      ),
      child: CustomAppCard(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.code,
                  style: AppTypography.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  site.name,
                  maxLines: 2,
                  style: AppTypography.heading2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        '${site.address}, ${site.city}, ${site.state}',
                        maxLines: 2,
                        style: AppTypography.bodyPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16),
                    const SizedBox(width: AppSpacing.s),
                    Text(
                      "Last Updated: ${DateFormat('MMM dd, yyyy').format(site.updatedAt)}",
                      style: AppTypography.bodyPrimary,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: SiteStatusWidget(status: site.status),
            ),
          ],
        ),
      ),
    );
  }
}
