import 'package:equatable/equatable.dart';

abstract class QuickTaskState extends Equatable {
  const QuickTaskState();

  @override
  List<Object?> get props => [];
}

class QuickTaskInitial extends QuickTaskState {}

class QuickTaskCreating extends QuickTaskState {}

class QuickTaskCreated extends QuickTaskState {
  final String? taskId;

  const QuickTaskCreated({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class QuickTaskError extends QuickTaskState {
  final String message;

  const QuickTaskError({required this.message});

  @override
  List<Object?> get props => [message];
}