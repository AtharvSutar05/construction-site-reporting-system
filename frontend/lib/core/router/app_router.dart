import 'package:frontend/core/router/go_router_refresh_stream.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:frontend/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:frontend/features/reports/presentation/screens/reports_screen.dart';
import 'package:frontend/features/sites/presentation/screens/create_site_screen.dart';
import 'package:frontend/features/sites/presentation/screens/site_detail_screen.dart';
import 'package:frontend/features/sites/presentation/screens/sites_screen.dart';
import 'package:frontend/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:frontend/shared/main_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: RoutePaths.dashboard,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final currentPath = state.matchedLocation;

        // 1. While auth state is initializing or checking session, do not redirect
        // deep links. The root splash overlay handles the UI while preserving the target route.
        if (authState is AuthInitial || authState is AuthChecking) {
          return null;
        }

        // 2. Action loading (login/register form submission in progress) - do not interrupt.
        if (authState is AuthLoading) {
          return null;
        }

        final isGoingToSplash = currentPath == RoutePaths.splash;
        final isGoingToLogin = currentPath == RoutePaths.login;
        final isGoingToRegister = currentPath == RoutePaths.register;
        final isGoingToAuth = isGoingToLogin || isGoingToRegister;

        // 3. Authenticated user flow
        if (authState is AuthAuthenticated) {
          // If authenticated user lands on splash, login, or register -> redirect to dashboard
          if (isGoingToSplash || isGoingToAuth) {
            return RoutePaths.dashboard;
          }
          // Allow access to requested protected route (/tasks, /sites, /reports, etc.)
          return null;
        }

        // 4. Unauthenticated user flow
        if (authState is AuthUnauthenticated || authState is AuthFailure) {
          // Allow access to login and register screens
          if (isGoingToAuth) {
            return null;
          }
          // Redirect unauthenticated access on protected routes or root splash to login
          return RoutePaths.login;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),

        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          builder: (context, state) => const RegisterScreen(),
        ),

        ShellRoute(
          builder: (context, state, child) {
            return MainScreen(child: child);
          },
          routes: [
            GoRoute(
              path: RoutePaths.dashboard,
              name: RouteNames.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: RoutePaths.sites,
              name: RouteNames.sites,
              builder: (context, state) => const SitesScreen(),
              routes: [
                GoRoute(
                    path: RoutePaths.createSite,
                    name: RouteNames.createSite,
                    builder: (context, state) => const CreateSiteScreen()
                ),
                GoRoute(
                  path: RoutePaths.siteDetail,
                  name: RouteNames.siteDetail,
                  builder: (context, state) =>
                      SiteDetailScreen(siteId: state.pathParameters['siteId']!),
                ),
              ],
            ),
            GoRoute(
              path: RoutePaths.tasks,
              name: RouteNames.tasks,
              builder: (context, state) => const TasksScreen(),
            ),
            GoRoute(
              path: RoutePaths.reports,
              name: RouteNames.reports,
              builder: (context, state) => const ReportsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
