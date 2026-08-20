import 'package:equatable/equatable.dart';

abstract class SitesEvent extends Equatable {
  const SitesEvent();

  @override
  List<Object?> get props => [];
}

class LoadSites extends SitesEvent {}