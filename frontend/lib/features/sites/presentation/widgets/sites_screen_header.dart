import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class SitesScreenHeader extends StatelessWidget {
  const SitesScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sites",
                style: AppTypography.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                "Manage and monitor all construction sites.",
                maxLines: 2,
                style: AppTypography.caption.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        // TODO: This will be only visible for admin and manager
        FilledButton(
          onPressed: () => context.goNamed(RouteNames.createSite),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.l,
            ),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
          ),
          child: Row(
            children: [
              Icon(Icons.add),
              const SizedBox(width: AppSpacing.s),
              Text("Create Site"),
            ],
          ),
        ),
      ],
    );
  }
}
