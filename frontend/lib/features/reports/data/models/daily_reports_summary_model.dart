import 'package:frontend/core/enums/report_status.dart';

class DailyReportsSummaryModel {
  final String id;
  final String creatorName;
  final DateTime reportDate;
  final ReportStatus status;
  final DateTime? submittedAt;

  const DailyReportsSummaryModel({
    required this.id,
    required this.creatorName,
    required this.reportDate,
    required this.status,
    this.submittedAt,
  });

  factory DailyReportsSummaryModel.fromJson(Map<String, dynamic> json) {
    return DailyReportsSummaryModel(
      id: json['id'],
      creatorName: json['creatorName'],
      reportDate: DateTime.parse(json['reportDate'] as String),
      status: ReportStatus.fromString(json['status']),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
    );
  }
}
