import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/presentation/screens/splash_screen.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SplashScreen renders progress indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
