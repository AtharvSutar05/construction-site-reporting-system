import 'package:frontend/features/reports/data/models/daily_reports_query.dart';
import 'package:frontend/features/reports/data/models/daily_reports_summary_response.dart';
import 'package:frontend/features/reports/data/services/daily_reports_service.dart';

class DailyReportsRepository {
  final DailyReportsService _dailyReportsService = DailyReportsService();
  Future<DailyReportsSummaryResponse> getSiteReports({
    required String siteId,
    required DailyReportsQuery query,
  }) async {
    return _dailyReportsService.getSiteReports(siteId: siteId, query: query);
  }
}
