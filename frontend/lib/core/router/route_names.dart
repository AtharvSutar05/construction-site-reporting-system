class RoutePaths {
  RoutePaths._();
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String dashboard = '/dashboard';
  static const String sites = '/sites';
  static const String tasks = '/tasks';
  static const String reports = '/reports';
  static const String profile = '/profile';

  // ── Nested Routes (relative paths) ──
  // These go INSIDE a parent GoRoute as children.
  // ':siteId' is a path parameter — GoRouter extracts it for you.
  static const String siteDetail = ':siteId'; // → /sites/:siteId
  static const String siteMembers = 'members'; // → /sites/:siteId/members
  static const String siteTasks = 'tasks'; // → /sites/:siteId/tasks
  static const String taskDetail = ':taskId'; // → /tasks/:taskId
  static const String reportDetail = ':reportId'; // → /reports/:reportId
  static const String company = 'company'; // → /profile/company
  static const String companyMembers = 'members'; // → /profile/company/members
}

class RouteNames {
  RouteNames._();

  // ── Auth ──
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';

  // ── Tabs ──
  static const String dashboard = 'dashboard';
  static const String sites = 'sites';
  static const String tasks = 'tasks';
  static const String reports = 'reports';
  static const String profile = 'profile';

  // ── Nested ──
  static const String siteDetail = 'siteDetail';
  static const String siteMembers = 'siteMembers';
  static const String siteTasks = 'siteTasks';
  static const String taskDetail = 'taskDetail';
  static const String reportDetail = 'reportDetail';
  static const String company = 'company';
  static const String companyMembers = 'companyMembers';
}
