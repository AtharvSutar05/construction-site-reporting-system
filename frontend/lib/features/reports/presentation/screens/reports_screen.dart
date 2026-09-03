import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/shared/widgets/cards/custom_app_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            CustomAppCard(
              child: Column(
                children: [Text("Reports", style: AppTypography.bodyPrimary)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
