import 'package:flutter/material.dart';
import 'package:frontend/core/router/go_router_refresh_stream.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page.dart';
import 'package:frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:frontend/features/auth/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: RouteNames.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isGoingToSplash = state.matchedLocation == RouteNames.splash;
        final isGoingToLogin = state.matchedLocation == RouteNames.login;
        final isGoingToRegister = state.matchedLocation == RouteNames.register;
        final isGoingToDashboard =
            state.matchedLocation == RouteNames.dashboard;

        if (authState is AuthInitial) {
          if (!isGoingToSplash) {
            return RouteNames.splash;
          }
          return null;
        } else if (authState is AuthAuthenticated) {
          if (!isGoingToDashboard) {
            return RouteNames.dashboard;
          }
          return null;
        } else if (authState is AuthUnauthenticated ||
            authState is AuthFailure) {
          if (!isGoingToLogin && !isGoingToRegister) {
            return RouteNames.login;
          }
        }
        return null;
      },
      routes: [
        // Splash
        GoRoute(
          path: RouteNames.splash,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashPage();
          },
        ),
        // Login
        GoRoute(
          path: RouteNames.login,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        // Register
        GoRoute(
          path: RouteNames.register,
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
        // Dashboard
        GoRoute(
          path: RouteNames.dashboard,
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardPage();
          },
        ),
      ],
    );
  }
}
