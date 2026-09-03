import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/dashboard/presentation/widgets/responsive.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_stats/site_quick_stats_bloc.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_stats/site_quick_stats_state.dart';
import 'package:go_router/go_router.dart';

class SiteQuickStatsWidget extends StatelessWidget {
  final String siteId;
  const SiteQuickStatsWidget({super.key, required this.siteId});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.isDesktop(context)
        ? 3
        : Responsive.isTablet(context)
        ? 3
        : 2;

    return BlocBuilder<SiteQuickStatsBloc, SiteQuickStatsState>(
      builder: (context, state) {
        if (state is SiteQuickStatsLoading) {
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.m,
            crossAxisSpacing: AppSpacing.m,
            childAspectRatio: 3,
            children: List.generate(3, (_) => loadingQuickStatCard()),
          );
        }

        if (state is SiteQuickStatsLoaded || state is SiteQuickStatsError) {
          final stats = state is SiteQuickStatsLoaded
              ? state.siteQuickStats
              : null;
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.m,
            crossAxisSpacing: AppSpacing.m,
            childAspectRatio: Responsive.isMobile(context) ? 2.4 : 3.2,
            children: [
              QuickStatCard(
                onTap: () => context.goNamed(
                  RouteNames.siteReports,
                  pathParameters: {'siteId': siteId}
                ),
                title: 'Reports',
                value: "${stats?.totalReports ?? 0}",
                icon: Icons.description_outlined,
              ),
              QuickStatCard(
                onTap: () {},
                title: 'Tasks',
                value: "${stats?.totalTasks ?? 0}",
                icon: Icons.task_alt_sharp,
              ),
              QuickStatCard(
                onTap: () {},
                title: 'Members',
                value: "${stats?.totalMembers ?? 0}",
                icon: Icons.people_outline,
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
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
  final GestureTapCallback onTap;
  final String title;
  final String value;
  final IconData icon;

  const QuickStatCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: AppRadius.md,
                ),
                padding: EdgeInsets.all(AppSpacing.s),
                child: Icon(icon, color: AppColors.primary),
              ),
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
      ),
    );
  }
}
