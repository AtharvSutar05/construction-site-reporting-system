import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/sites/data/repositories/site_repository.dart';
import 'package:frontend/features/sites/presentation/bloc/site_detail/site_detail_event.dart';
import 'package:frontend/features/sites/presentation/bloc/site_detail/site_detail_state.dart';

class SiteDetailBloc extends Bloc<SiteDetailEvent, SiteDetailState> {
  final SiteRepository _siteRepository;
  SiteDetailBloc({required SiteRepository siteRepository})
    : _siteRepository = siteRepository,
      super(SiteDetailLoading()) {
    on<LoadSiteDetail>(onLoadSiteDetail);
  }

  Future<void> onLoadSiteDetail(
    LoadSiteDetail event,
    Emitter<SiteDetailState> emit,
  ) async {
    try {
      final site = await _siteRepository.getSiteDetail(event.siteId);
      emit(SiteDetailLoaded(site: site));
    } catch (e) {
      emit(SiteDetailError(message: e.toString()));
    }
  }
}
