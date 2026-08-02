import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RouteNames.dashboard);
        } else if (state is AuthUnauthenticated || state is AuthFailure) {
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'logos/site_flow_logo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  color: Color(0xFFDC9728),
                  backgroundColor: Color(0xFFF3E7D3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
