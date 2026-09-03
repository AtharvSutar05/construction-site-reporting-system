import 'package:equatable/equatable.dart';
import 'package:frontend/core/enums/report_status.dart';

class DailyReportsQuery extends Equatable {
  final String? fromDate;
  final String? toDate;
  final ReportStatus? status;
  final int page;
  final int limit;

  const DailyReportsQuery({
    this.fromDate,
    this.toDate,
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      if (fromDate != null) 'fromDate': fromDate,
      if (toDate != null) 'toDate': toDate,
      if (status != null) 'status': status!.name,
      'page': page,
      'limit': limit,
    };
  }

  DailyReportsQuery copyWith({
    String? fromDate,
    String? toDate,
    ReportStatus? status,
    int? page,
    int? limit,
  }) {
    return DailyReportsQuery(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      status: status ?? this.status,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
    fromDate,
    toDate,
    status,
    page,
    limit,
  ];
}