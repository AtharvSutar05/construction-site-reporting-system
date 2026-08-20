import 'package:equatable/equatable.dart';
import 'package:frontend/features/sites/data/models/site_model.dart';

abstract class SitesState extends Equatable {
  const SitesState();

  @override
  List<Object?> get props => [];
}

class SitesLoading extends SitesState {}

class SitesLoaded extends SitesState {
  final List<SiteModel> sites;

  const SitesLoaded({required this.sites});

  @override
  List<Object?> get props => [sites];
}

class SitesError extends SitesState {
  final String message;

  const SitesError({required this.message});

  @override
  List<Object?> get props => [message];
}
