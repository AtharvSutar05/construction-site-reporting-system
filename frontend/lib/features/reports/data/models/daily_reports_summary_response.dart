import 'package:frontend/features/reports/data/models/daily_reports_summary_model.dart';
import 'package:frontend/shared/models/pagination_model.dart';

class DailyReportsSummaryResponse {
  final List<DailyReportsSummaryModel> reports;
  final PaginationModel pagination;

  DailyReportsSummaryResponse({
    required this.reports,
    required this.pagination,
  });

  factory DailyReportsSummaryResponse.fromJson(Map<String, dynamic> json) {
    return DailyReportsSummaryResponse(
      reports: (json['reports'] as List)
          .map((report) => DailyReportsSummaryModel.fromJson(report))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}
