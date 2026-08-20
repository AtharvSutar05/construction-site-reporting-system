import 'package:equatable/equatable.dart';

abstract class SiteDetailEvent extends Equatable {
  const SiteDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadSiteDetail extends SiteDetailEvent {
  final String siteId;

  const LoadSiteDetail({required this.siteId});

  @override
  List<Object?> get props => [siteId];
}