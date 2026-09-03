import 'package:equatable/equatable.dart';
import 'package:frontend/features/sites/data/models/site_quick_stats_model.dart';

abstract class SiteQuickStatsState extends Equatable {
  const SiteQuickStatsState();

  @override
  List<Object?> get props => [];
}
class SiteQuickStatsInitial extends SiteQuickStatsState {}

class SiteQuickStatsLoading extends SiteQuickStatsState {}

class SiteQuickStatsLoaded extends SiteQuickStatsState {
  final SiteQuickStatsModel siteQuickStats;

  const SiteQuickStatsLoaded({required this.siteQuickStats});

  @override
  List<Object?> get props => [siteQuickStats];
}

class SiteQuickStatsError extends SiteQuickStatsState {
  final String message;

  const SiteQuickStatsError({required this.message});

  @override
  List<Object?> get props => [message];
}
