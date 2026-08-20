import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/sites/data/repositories/site_repository.dart';
import 'package:frontend/features/sites/presentation/bloc/sites/sites_event.dart';
import 'package:frontend/features/sites/presentation/bloc/sites/sites_state.dart';


class SitesBloc extends Bloc<SitesEvent, SitesState> {
  final SiteRepository _siteRepository = SiteRepository();
  SitesBloc() : super(SitesLoading()) {
    on<LoadSites>(onLoadSites);
  }

  Future<void> onLoadSites(
      LoadSites event,
      Emitter<SitesState> emit
      ) async {
    try {
      final sites = await _siteRepository.getSites();
      emit(SitesLoaded(sites: sites));
    } catch(e) {
      emit(SitesError(message: e.toString()));
    }
  }
}