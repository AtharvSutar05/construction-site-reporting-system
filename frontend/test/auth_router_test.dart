import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import 'package:frontend/core/router/route_names.dart';

void main() {
  group('AuthState Tests', () {
    test('AuthChecking state exists and extends AuthState', () {
      final state = AuthChecking();
      expect(state, isA<AuthState>());
      expect(state.props, isEmpty);
    });

    test('AuthAuthenticated holds user model', () {
      final user = UserModel(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
      );
      final state = AuthAuthenticated(user: user);
      expect(state.user.name, 'John Doe');
      expect(state.props, [user]);
    });
  });

  group('Route Path Definitions', () {
    test('Paths are defined with leading slash', () {
      expect(RoutePaths.dashboard, '/dashboard');
      expect(RoutePaths.sites, '/sites');
      expect(RoutePaths.tasks, '/tasks');
      expect(RoutePaths.reports, '/reports');
      expect(RoutePaths.login, '/login');
      expect(RoutePaths.register, '/register');
      expect(RoutePaths.splash, '/');
    });
  });
}
