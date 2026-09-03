import 'package:equatable/equatable.dart';
import 'package:frontend/features/sites/data/models/quick_task_model.dart';

abstract class QuickTaskEvent extends Equatable {
  const QuickTaskEvent();

  @override
  List<Object?> get props => [];
}

class CreateQuickTaskRequested extends QuickTaskEvent {
  final String siteId;
  final QuickTaskModel task;

  const CreateQuickTaskRequested({required this.siteId, required this.task});

  @override
  List<Object?> get props => [siteId, task];
}