import 'package:equatable/equatable.dart';
import 'package:frontend/features/sites/data/models/create_site_model.dart';

abstract class CreateSiteEvent extends Equatable {
  const CreateSiteEvent();

  @override
  List<Object?> get props => [];
}

class CreateSiteRequested extends CreateSiteEvent {
  final CreateSiteModel site;

  const CreateSiteRequested({
    required this.site,
  });

  @override
  List<Object?> get props => [site];
}