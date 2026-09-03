import 'package:equatable/equatable.dart';

abstract class SiteQuickStatsEvent extends Equatable {
  const SiteQuickStatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSiteQuickStats extends SiteQuickStatsEvent {
  final String siteId;

  const LoadSiteQuickStats({required this.siteId});

  @override
  List<Object?> get props => [siteId];
}