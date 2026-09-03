import 'package:equatable/equatable.dart';
import 'package:frontend/features/reports/data/models/daily_reports_query.dart';
import 'package:frontend/features/reports/data/models/daily_reports_summary_model.dart';
import 'package:frontend/shared/models/pagination_model.dart';

abstract class DailyReportsState extends Equatable {
  const DailyReportsState();

  @override
  List<Object?> get props => [];
}

class DailyReportsInitial extends DailyReportsState {
  const DailyReportsInitial();
}

class DailyReportsLoading extends DailyReportsState {
  const DailyReportsLoading();
}

class DailyReportsLoaded extends DailyReportsState {
  final List<DailyReportsSummaryModel> reports;
  final PaginationModel pagination;
  final DailyReportsQuery query;
  final bool isLoadingMore;

  const DailyReportsLoaded({
    required this.reports,
    required this.pagination,
    required this.query,
    this.isLoadingMore = false,
  });

  DailyReportsLoaded copyWith({
    List<DailyReportsSummaryModel>? reports,
    PaginationModel? pagination,
    DailyReportsQuery? query,
    bool? isLoadingMore,
  }) {
    return DailyReportsLoaded(
      reports: reports ?? this.reports,
      pagination: pagination ?? this.pagination,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    reports,
    pagination,
    query,
    isLoadingMore,
  ];
}

class DailyReportsError extends DailyReportsState {
  final String message;

  const DailyReportsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}