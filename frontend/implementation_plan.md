# Responsive Dashboard Implementation Plan

Based on the analysis of the backend architecture (Express.js + Drizzle ORM + PostgreSQL), this plan outlines the construction of an enterprise-grade, responsive Flutter Dashboard for the **Construction Site Management System**.

---

## 1. Backend Architecture Analysis Summary

The backend revolves around the following core entities and REST APIs:

| Module | Key Endpoints | Dashboard Data Mapping |
| :--- | :--- | :--- |
| **Auth & Profile** | `GET /api/v1/auth/me` | Current user info, authentication state |
| **Company & Roles** | `GET /api/v1/company/me`<br>`GET /api/v1/company-members` | Active company context, member roster, role-based capabilities (`admin`, `manager`, `engineer`) |
| **Sites** | `GET /api/v1/sites`<br>`GET /api/v1/sites/:siteId` | Project sites, codes, locations, coordinates, and status (`ACTIVE`, `ON_HOLD`, `COMPLETED`, `ARCHIVED`) |
| **Tasks** | `GET /api/v1/sites/:siteId/tasks` | Work items with status (`OPEN`, `IN_PROGRESS`, `COMPLETED`, `PENDING`, `CANCELLED`), priority (`LOW`, `MEDIUM`, `HIGH`, `CRITICAL`), due dates |
| **Daily Reports** | `GET /api/v1/sites/:siteId/daily-reports/today`<br>`GET /api/v1/sites/:siteId/daily-reports/me` | Daily site activity logs, weather conditions, on-site manpower counts, report approval status (`DRAFT`, `SUBMITTED`, `APPROVED`, `REJECTED`) |
| **Issues & Blockers** | `GET /api/v1/daily-reports/:reportId/task-progress` | On-site delays and problems categorized by type (`SAFETY`, `MATERIAL`, `MACHINE`, `LABOUR`, `WEATHER`, `DESIGN`, `CLIENT`, `OTHER`) |
| **Site Assignments** | `GET /api/v1/site-assignments` | Sites assigned to the current member and team allocation |

---

## 2. Responsive UI/UX Design Strategy

To deliver an adaptive experience across Mobile, Tablet, and Desktop screens:

```
+---------------------------------------------------------------------------------------------------+
|  DESKTOP (> 1024px)                                                                               |
|  +----------------+-----------------------------------------------------------------------------+ |
|  |                | [ Top Bar: Company / Site Filter | Weather | Quick Actions | User Profile ]  | |
|  |                |-----------------------------------------------------------------------------| |
|  |  Collapsible   | [ KPI Metrics: Active Sites | Ongoing Tasks | Manpower | Issues | Reports ] | |
|  |  Sidebar Nav   |-----------------------------------------------------------------------------| |
|  |  (Sites, Tasks,| [ Left Column (60%):                  ] [ Right Column (40%):               ] | |
|  |   Reports,     | [ - Active Sites Overview Grid        ] [ - Today's Daily Reports & Review  ] | |
|  |   Team, Logs)  | [ - Task Priority & Status Breakdown  ] [ - Critical Issues & Site Alerts   ] | |
|  |                | [ - Manpower & Weather Conditions     ] [ - Team On-Site Availability       ] | |
|  +----------------+-----------------------------------------------------------------------------+ |
+---------------------------------------------------------------------------------------------------+

+-------------------------------------------------+   +---------------------------------------+
|  TABLET (650px - 1024px)                        |   |  MOBILE (< 650px)                     |
|  - Collapsed mini rail or Drawer navigation     |   |  - Mobile App Bar with Drawer toggle  |
|  - 2-Column KPI cards & stacked sections        |   |  - 2x2 KPI Grid or Horizontal pills   |
|  - Side-by-side site cards and task status      |   |  - Vertically stacked feed & cards    |
|  - Full touch-friendly target sizing            |   |  - Floating Action Button (FAB)       |
+-------------------------------------------------+   +---------------------------------------+
```

---

## 3. Proposed Frontend Architecture & Changes

### A. Data Layer (`lib/features/dashboard/data/`)
- [NEW] `models/dashboard_summary_model.dart`: Unified data model encapsulating KPI metrics, site summaries, task breakdown, today's reports, and site issues.
- [NEW] `models/site_summary_model.dart`: Site entity with location, status, task progress, and assigned member count.
- [NEW] `models/task_summary_model.dart`: Task entity with priority, status, site association, and due dates.
- [NEW] `models/daily_report_summary_model.dart`: Daily reports with weather, manpower, status, and remarks.
- [NEW] `models/issue_summary_model.dart`: Issue tracking model with category badges and task linkages.
- [NEW] `services/dashboard_api_service.dart`: API service integrating backend endpoints with resilient caching and sample fallback.
- [NEW] `repositories/dashboard_repository.dart`: Repository handling dashboard aggregation and site-specific filtering.

### B. State Management Layer (`lib/features/dashboard/presentation/bloc/`)
- [NEW] `bloc/dashboard_bloc.dart`: Handles loading, live refreshing, and filtering by site or status.
- [NEW] `bloc/dashboard_event.dart`: `DashboardFetchData`, `DashboardRefreshData`, `DashboardFilterBySite`, `DashboardSelectDate`.
- [NEW] `bloc/dashboard_state.dart`: `DashboardInitial`, `DashboardLoading`, `DashboardLoaded`, `DashboardError`.

### C. Presentation & Responsive UI Layer (`lib/features/dashboard/presentation/widgets/`)
- [NEW] `widgets/responsive_layout_builder.dart`: Adaptive layout utility for desktop, tablet, and mobile breakpoints.
- [NEW] `widgets/dashboard_sidebar.dart`: Branded industrial sidebar with navigation items, company switcher, and role indicator.
- [NEW] `widgets/dashboard_top_bar.dart`: Search bar, site selector dropdown, weather badge, notifications, and profile action.
- [NEW] `widgets/dashboard_kpi_card.dart`: Metric cards with color-coded gradients, icons, values, and trend indicators.
- [NEW] `widgets/site_status_grid.dart`: Cards displaying site health, active tasks, manpower, and progress indicator.
- [NEW] `widgets/task_priority_board.dart`: Task tracker showing critical/high priority items and status pills.
- [NEW] `widgets/today_reports_feed.dart`: List of today's daily reports with approval status pills and manpower counts.
- [NEW] `widgets/site_issues_alert_card.dart`: Warning card highlighting on-site blockers (Safety, Material, Machine).
- [NEW] `widgets/manpower_weather_widget.dart`: Visual breakdown of weather and workforce deployed across sites.
- [MODIFY] `pages/dashboard_page.dart`: Upgraded to full responsive layout using `DashboardBloc`, `ResponsiveLayoutBuilder`, and modular dashboard components.

---

## 4. Verification Plan

### Automated Verification
1. Run `flutter analyze` to ensure 0 lint or compilation issues:
   ```bash
   flutter analyze
   ```
2. Verify all models parse JSON structures from backend endpoints correctly.

### Manual Verification
1. Test responsive layout at different window sizes (Desktop > 1024px, Tablet 768px, Mobile 375px).
2. Test site filtering (Company-wide vs specific project site).
3. Test pull-to-refresh and error handling states.
4. Verify role badges, KPI stats, task priority badges, report approval status tags, and issue warnings render cleanly with proper contrast and theme colors.
