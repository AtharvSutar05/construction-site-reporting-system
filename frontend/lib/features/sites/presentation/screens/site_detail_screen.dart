import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/features/sites/presentation/bloc/site_detail/site_detail_bloc.dart';
import 'package:frontend/features/sites/presentation/bloc/site_detail/site_detail_event.dart';
import 'package:frontend/features/sites/presentation/bloc/site_detail/site_detail_state.dart';
import 'package:frontend/features/sites/presentation/widgets/site_info_card.dart';
import 'package:frontend/features/sites/presentation/widgets/site_quick_stats_widget.dart';

class SiteDetailScreen extends StatelessWidget {
  final String siteId;
  const SiteDetailScreen({super.key, required this.siteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SiteDetailBloc()..add(LoadSiteDetail(siteId: siteId)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SiteDetailBloc, SiteDetailState>(
                builder: (context, state) {
                  if (state is SiteDetailLoading) {
                    return Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: AppColors.loading.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.mdValue)
                      ),
                    );
                  }
                  if (state is SiteDetailLoaded) {
                    return SiteInfoCard(site: state.site);
                  }
                  return SizedBox.shrink();
                },
              ),
              const SizedBox(height: AppSpacing.m,),
              const SiteQuickStatsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

