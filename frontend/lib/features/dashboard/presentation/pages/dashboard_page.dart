import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/route_names.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Welcome ${state.user.name} to SiteFlow"),
                  IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogOutRequested());
                      context.go(RouteNames.login);
                    },
                    icon: Icon(Icons.login, color: Colors.red),
                  ),
                ],
              );
            }
            print(state.toString());
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
