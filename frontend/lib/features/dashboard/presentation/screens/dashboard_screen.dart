import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return Text(
                        "Welcome ${state.user.name}!",
                        style: AppTypography.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),

                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person_rounded, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
