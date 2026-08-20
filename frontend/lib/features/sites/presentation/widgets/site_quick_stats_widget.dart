import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/dashboard/presentation/widgets/responsive.dart';

class SiteQuickStatsWidget extends StatelessWidget {
  const SiteQuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.isDesktop(context)
        ? 4
        : Responsive.isTablet(context)
        ? 4
        : 2;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: AppSpacing.m,
      crossAxisSpacing: AppSpacing.m,
      childAspectRatio: Responsive.isMobile(context) ? 2.4 : 3.2,
      children: false
          ? [
              loadingQuickStatCard(),
              loadingQuickStatCard(),
              loadingQuickStatCard(),
              loadingQuickStatCard(),
            ]
          : const [
              QuickStatCard(
                title: 'Reports',
                value: '24',
                icon: Icons.description_outlined,
              ),
              QuickStatCard(
                title: 'Issues',
                value: '5',
                icon: Icons.warning_amber_rounded,
              ),
              QuickStatCard(title: 'Tasks', value: '18', icon: Icons.task_alt),
              QuickStatCard(
                title: 'Members',
                value: '7',
                icon: Icons.people_outline,
              ),
            ],
    );
  }
}

Widget loadingQuickStatCard() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.loading.withValues(alpha: 0.15),
      borderRadius: AppRadius.md,
    ),
  );
}

class QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const QuickStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 20, child: Icon(icon)),
            const SizedBox(width: AppSpacing.m),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: AppTypography.heading2),
                  Text(title, style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
