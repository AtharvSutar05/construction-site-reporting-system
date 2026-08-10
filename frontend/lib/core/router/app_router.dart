import 'package:frontend/core/router/go_router_refresh_stream.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page.dart';
import 'package:frontend/features/auth/presentation/pages/splash_page.dart';
import 'package:frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final currentPath = state.matchedLocation;

        final isGoingToSplash = currentPath == RoutePaths.splash;
        final isGoingToLogin = currentPath == RoutePaths.login;
        final isGoingToRegister = currentPath == RoutePaths.register;
        if (authState is AuthInitial) {
          return isGoingToSplash ? null : RoutePaths.splash;
        }
        if (authState is AuthAuthenticated) {
          if (isGoingToSplash || isGoingToLogin || isGoingToRegister) {
            return RoutePaths.dashboard;
          }
          return null;
        }
        if (authState is AuthUnauthenticated || authState is AuthFailure) {
          if (!isGoingToLogin && !isGoingToRegister) {
            return RoutePaths.login;
          }
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),

        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),

        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          builder: (context, state) => const RegisterPage(),
        ),

        GoRoute(
          path: RoutePaths.dashboard,
          name: RouteNames.dashboard,
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    );
  }
}
