import 'package:equatable/equatable.dart';
import 'package:frontend/core/enums/report_status.dart';

abstract class DailyReportsEvent extends Equatable {
  const DailyReportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyReports extends DailyReportsEvent {
  const LoadDailyReports();
}

class LoadMoreDailyReports extends DailyReportsEvent {
  const LoadMoreDailyReports();
}

class FilterDailyReports extends DailyReportsEvent {
  final String? fromDate;
  final String? toDate;
  final ReportStatus? status;

  const FilterDailyReports({
    this.fromDate,
    this.toDate,
    this.status,
  });

  @override
  List<Object?> get props => [
    fromDate,
    toDate,
    status,
  ];
}

class ClearDailyReportFilters extends DailyReportsEvent {
  const ClearDailyReportFilters();
}