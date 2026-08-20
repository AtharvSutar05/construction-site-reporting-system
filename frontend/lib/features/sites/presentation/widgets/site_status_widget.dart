import 'package:flutter/material.dart';
import 'package:frontend/core/enums/site_status.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';

class SiteStatusWidget extends StatelessWidget {
  final SiteStatus status;
  const SiteStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getStatusColor(status).withValues(alpha: 0.15),
        borderRadius: AppRadius.xs,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xxs,
      ),
      child: Text(
        status.displayName,
        style: AppTypography.statLabel.copyWith(
          color: getStatusColor(status),
        ),
      ),
    );
  }
}

Color getStatusColor(SiteStatus status) {
  switch (status) {
    case SiteStatus.active:
      return Colors.green;

    case SiteStatus.completed:
      return Colors.blue;

    case SiteStatus.onHold:
      return Colors.orange;

    case SiteStatus.archived:
      return Colors.grey;
  }
}
