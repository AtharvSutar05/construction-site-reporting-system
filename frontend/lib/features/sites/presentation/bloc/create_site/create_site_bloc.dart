import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/sites/data/repositories/site_repository.dart';

import 'create_site_event.dart';
import 'create_site_state.dart';

class CreateSiteBloc extends Bloc<CreateSiteEvent, CreateSiteState> {
  final SiteRepository _repository;

  CreateSiteBloc({required SiteRepository repository})
    : _repository = repository,
      super(CreateSiteInitial()) {
    on<CreateSiteRequested>(_onCreateSiteRequested);
  }

  Future<void> _onCreateSiteRequested(
    CreateSiteRequested event,
    Emitter<CreateSiteState> emit,
  ) async {
    emit(CreateSiteLoading());

    try {
      final site = await _repository.createSite(event.site);

      emit(CreateSiteSuccess(siteId: site.id));
    } catch (e) {
      if (e is ApiException) {
        emit(CreateSiteFailure(message: e.message));
      } else {
        emit(CreateSiteFailure(message: e.toString()));
      }
    }
  }
}
