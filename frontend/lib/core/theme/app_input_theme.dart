import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radius.dart';

abstract class AppInputTheme {
  // Shared Padding & Radius
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 14.0,
  );

  // ---------------------------------------------------------------------------
  // Global InputDecorationTheme
  // ---------------------------------------------------------------------------
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    // Text Styles
    labelStyle: AppTypography.inputLabel,
    hintStyle: AppTypography.inputHint,
    errorStyle: AppTypography.caption.copyWith(color: AppColors.error),

    // Colors & Fill
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: _contentPadding,

    // Icon Colors
    prefixIconColor: AppColors.textSecondary,
    suffixIconColor: AppColors.textSecondary,

    // --- Borders ---

    // Default Unfocused Border
    border: const OutlineInputBorder(
      borderRadius: AppRadius.sm,
      borderSide: BorderSide(color: AppColors.border, width: 1.0),
    ),

    // Enabled (Idle state)
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadius.sm,
      borderSide: BorderSide(color: AppColors.border, width: 1.0),
    ),

    // Focused State (Active Input)
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadius.sm,
      borderSide: BorderSide(color: AppColors.primary, width: 1.0),
    ),

    // Error State
    errorBorder: const OutlineInputBorder(
      borderRadius: AppRadius.sm,
      borderSide: BorderSide(color: AppColors.error, width: 1.0),
    ),

    // Focused Error State
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: AppRadius.sm,
      borderSide: BorderSide(color: AppColors.error, width: 1.0),
    ),

    // Disabled State
    disabledBorder: const OutlineInputBorder(
      borderRadius: AppRadius.sm,
      borderSide: BorderSide(color: AppColors.border, width: 1.0),
    ),
  );
}