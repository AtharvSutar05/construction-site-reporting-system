import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';

class LoadingSiteCard extends StatelessWidget {
  const LoadingSiteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.loading.withValues(alpha: 0.15),
        borderRadius: AppRadius.md
      ),
    );
  }
}
