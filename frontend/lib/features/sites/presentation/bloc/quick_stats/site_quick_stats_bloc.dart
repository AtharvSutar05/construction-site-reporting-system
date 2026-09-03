import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/sites/data/repositories/site_repository.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_stats/site_quick_stats_event.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_stats/site_quick_stats_state.dart';

class SiteQuickStatsBloc
    extends Bloc<SiteQuickStatsEvent, SiteQuickStatsState> {
  final SiteRepository _siteRepository;
  SiteQuickStatsBloc({required SiteRepository siteRepository})
    : _siteRepository = siteRepository,
      super(SiteQuickStatsInitial()) {
    on<LoadSiteQuickStats>(_onLoadSiteQuickStats);
  }

  Future<void> _onLoadSiteQuickStats(
    LoadSiteQuickStats event,
    Emitter<SiteQuickStatsState> emit,
  ) async {
    emit(SiteQuickStatsLoading());
    try {
      final siteQuickStats = await _siteRepository.getSiteQuickStats(
        event.siteId,
      );
      emit(SiteQuickStatsLoaded(siteQuickStats: siteQuickStats));
    } catch (e) {
      emit(SiteQuickStatsError(message: e.toString()));
    }
  }
}
