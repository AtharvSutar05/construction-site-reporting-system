import 'package:flutter/material.dart';
import 'package:frontend/core/enums/site_status.dart';
import 'package:frontend/features/sites/data/models/site_model.dart';
import 'package:frontend/features/sites/presentation/widgets/loading_site_card.dart';
import 'package:frontend/features/sites/presentation/widgets/site_card.dart';

class SiteListView extends StatelessWidget {
  final List<SiteModel> sites;
  final SiteStatus? status;
  final bool isLoading;

  const SiteListView({
    super.key,
    required this.sites,
    required this.status,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {

    final filteredSites = status == null
        ? sites
        : sites.where((site) => site.status == status).toList();

    if (isLoading) {
      return GridView.builder(
        itemCount: 5,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 450,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          return LoadingSiteCard();
        },
      );
    }

    if (filteredSites.isEmpty) {
      return const Center(child: Text('No sites found'));
    }

    return GridView.builder(
      itemCount: filteredSites.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 450,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        return SiteCard(site: filteredSites[index]);
      },
    );
  }
}
