import 'package:equatable/equatable.dart';
import 'package:frontend/features/sites/data/models/site_detail_model.dart';

abstract class SiteDetailState extends Equatable {
  const SiteDetailState();
  @override
  List<Object?> get props => [];
}

class SiteDetailLoading extends SiteDetailState {}

class SiteDetailLoaded extends SiteDetailState {
  final SiteDetailModel site;

  const SiteDetailLoaded({required this.site});

  @override
  List<Object?> get props => [site];
}

class SiteDetailError extends SiteDetailState {
  final String message;

  const SiteDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}