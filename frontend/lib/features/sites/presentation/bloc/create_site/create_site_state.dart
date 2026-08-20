import 'package:equatable/equatable.dart';

abstract class CreateSiteState extends Equatable {
  const CreateSiteState();

  @override
  List<Object?> get props => [];
}

class CreateSiteInitial extends CreateSiteState {}

class CreateSiteLoading extends CreateSiteState {}

class CreateSiteSuccess extends CreateSiteState {
  final String siteId;

  const CreateSiteSuccess({
    required this.siteId,
  });

  @override
  List<Object?> get props => [siteId];
}

class CreateSiteFailure extends CreateSiteState {
  final String message;

  const CreateSiteFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}