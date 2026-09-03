import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/sites/data/repositories/site_repository.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_task/quick_task_event.dart';
import 'package:frontend/features/sites/presentation/bloc/quick_task/quick_task_state.dart';

class QuickTaskBloc extends Bloc<QuickTaskEvent, QuickTaskState> {
  final SiteRepository _siteRepository;
  QuickTaskBloc({required SiteRepository siteRepository})
    : _siteRepository = siteRepository,
      super(QuickTaskInitial()) {
    on<CreateQuickTaskRequested>(_onCreateQuickTaskRequested);
  }

  Future<void> _onCreateQuickTaskRequested(
    CreateQuickTaskRequested event,
    Emitter<QuickTaskState> emit,
  ) async {
    emit(QuickTaskCreating());
    final taskId = await _siteRepository.createQuickTask(event.siteId, event.task);
    emit(QuickTaskCreated(taskId: taskId));
    try {} catch (e) {
      emit(QuickTaskError(message: e.toString()));
    }
  }
}
