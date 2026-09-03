class SiteQuickStatsModel {
  final int totalReports;
  final int totalTasks;
  final int totalMembers;

  SiteQuickStatsModel({
    required this.totalReports,
    required this.totalTasks,
    required this.totalMembers,
  });

  factory SiteQuickStatsModel.fromJson(Map<String, dynamic> json) {
    return SiteQuickStatsModel(
      totalReports: json['totalReports'],
      totalTasks: json['totalTasks'],
      totalMembers: json['totalMembers'],
    );
  }
}
