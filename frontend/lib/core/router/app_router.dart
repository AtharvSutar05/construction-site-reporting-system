import 'package:flutter/material.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page.dart';
import 'package:frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:frontend/features/auth/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // Splash
      GoRoute(
          path: RouteNames.splash,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashPage();
          }
      ),
      // Login
      GoRoute(
          path: RouteNames.login,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          }
      ),
      // Register
      GoRoute(
          path: RouteNames.register,
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          }
      ),
      // Dashboard
      GoRoute(
        path: RouteNames.dashboard,
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardPage();
          }
      )
    ],
  );
}