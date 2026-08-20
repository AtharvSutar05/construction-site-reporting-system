import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/enums/site_status.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/features/sites/data/models/site_model.dart';
import 'package:frontend/features/sites/presentation/bloc/sites/sites_bloc.dart';
import 'package:frontend/features/sites/presentation/bloc/sites/sites_state.dart';
import 'package:frontend/features/sites/presentation/widgets/site_list_view.dart';
import 'package:frontend/features/sites/presentation/widgets/sites_screen_header.dart';
import 'package:frontend/features/sites/presentation/widgets/sites_screen_tab_bar.dart';

class SitesScreen extends StatelessWidget {
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            const SitesScreenHeader(),
            const SizedBox(height: AppSpacing.m),
            const SitesScreenTabBar(),
            const SizedBox(height: AppSpacing.m),
            Expanded(
              child: BlocBuilder<SitesBloc, SitesState>(
                builder: (context, state) {
                  final isLoading = state is SitesLoading;
                  final List<SiteModel> sites = state is SitesLoaded
                      ? state.sites
                      : [];
                  return TabBarView(
                    children: [
                      SiteListView(
                        sites: sites,
                        status: null,
                        isLoading: isLoading,
                      ),
                      SiteListView(
                        sites: sites,
                        status: SiteStatus.active,
                        isLoading: isLoading,
                      ),
                      SiteListView(
                        sites: sites,
                        status: SiteStatus.onHold,
                        isLoading: isLoading,
                      ),
                      SiteListView(
                        sites: sites,
                        status: SiteStatus.completed,
                        isLoading: isLoading,
                      ),
                      SiteListView(
                        sites: sites,
                        status: SiteStatus.archived,
                        isLoading: isLoading,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
