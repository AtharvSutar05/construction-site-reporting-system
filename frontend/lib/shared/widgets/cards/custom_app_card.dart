import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_radius.dart';
import 'package:frontend/core/theme/app_spacing.dart';

class CustomAppCard extends StatelessWidget {
  final Widget child;
  const CustomAppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: EdgeInsets.all(AppSpacing.m),
      child: child,
    );
  }
}
