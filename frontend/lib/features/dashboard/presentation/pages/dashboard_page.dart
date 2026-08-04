import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';

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
                  Text("Welcome ${state.user.name}!"),
                  IconButton(
                    onPressed: () =>
                        context.read<AuthBloc>().add(LogOutRequested()),
                    icon: Icon(Icons.login, color: Colors.red),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
