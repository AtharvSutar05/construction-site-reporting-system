import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/dashboard/presentation/widgets/responsive.dart';
import 'package:frontend/features/sites/data/repositories/site_repository.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_stats/site_quick_stats_bloc.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_stats/site_quick_stats_event.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_task/quick_task_bloc.dart';
import 'package:frontend/features/sites/presentation/widgets/create_quick_task_widget.dart';
import 'package:frontend/features/sites/presentation/widgets/site_info_card.dart';
import 'package:frontend/features/sites/presentation/widgets/site_quick_stats_widget.dart';
import 'package:frontend/shared/widgets/cards/custom_app_card.dart';

class SiteDetailScreen extends StatelessWidget {
  final String siteId;
  const SiteDetailScreen({super.key, required this.siteId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SiteInfoCard(),
            const SizedBox(height: AppSpacing.m),
            BlocProvider(
              create: (context) => SiteQuickStatsBloc(
                siteRepository: context.read<SiteRepository>(),
              )..add(LoadSiteQuickStats(siteId: siteId)),
              child: SiteQuickStatsWidget(siteId: siteId),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: CustomAppCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.history, color: AppColors.primary),
                            const SizedBox(width: AppSpacing.s),
                            Text(
                              'Recent Activity',
                              style: AppTypography.bodyPrimary.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 320,
                          alignment: Alignment.center,
                          child: Text("No recent activities."),
                        ),
                      ],
                    ),
                  ),
                ),
                if (Responsive.isDesktop(context)) ...[
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    flex: 1,
                    child: BlocProvider(
                      create: (context) => QuickTaskBloc(
                        siteRepository: context.read<SiteRepository>(),
                      ),
                      child: CreateQuickTaskWidget(siteId: siteId),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
