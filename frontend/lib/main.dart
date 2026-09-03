import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:frontend/features/auth/presentation/screens/splash_screen.dart';
import 'package:frontend/features/sites/data/repositories/site_repository.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => SiteRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc()..add(AuthCheckRequested()),
            lazy: false,
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "SiteFlow",
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      builder: (context, child) {
        return BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) {
            final wasChecking =
                previous is AuthInitial || previous is AuthChecking;
            final isChecking =
                current is AuthInitial || current is AuthChecking;
            return wasChecking != isChecking;
          },
          builder: (context, state) {
            if (state is AuthInitial || state is AuthChecking) {
              return const SplashScreen();
            }
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
