import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/reports/data/models/daily_reports_query.dart';
import 'package:frontend/features/reports/data/models/daily_reports_summary_response.dart';

class DailyReportsService {
  final ApiClient _apiClient = ApiClient();

  Future<DailyReportsSummaryResponse> getSiteReports({
    required String siteId,
    required DailyReportsQuery query,
  }) async {
    final json = await _apiClient.get(
      'sites/$siteId/daily-reports',
      queryParameters: query.toQueryParameters(),
    );
    return DailyReportsSummaryResponse.fromJson(
      json['data'] as Map<String, dynamic>,
    );
  }
}
