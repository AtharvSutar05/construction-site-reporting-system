import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract class AppButtonTheme {
  // Shared base button properties
  static final BorderRadius _borderRadius = BorderRadius.circular(8.0);
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 14.0,
  );

  // ---------------------------------------------------------------------------
  // 1. PRIMARY BUTTON (ElevatedButton standard)
  // ---------------------------------------------------------------------------
  static FilledButtonThemeData get filledButtonTheme => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.border,
      disabledForegroundColor: AppColors.textDisabled,
      elevation: 0,
      padding: _padding,
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      textStyle: AppTypography.buttonLabel,
    )
  );
  // ---------------------------------------------------------------------------
  // 1. PRIMARY BUTTON (ElevatedButton standard)
  // ---------------------------------------------------------------------------
  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.border,
      disabledForegroundColor: AppColors.textDisabled,
      elevation: 0,
      padding: _padding,
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      textStyle: AppTypography.buttonLabel,
    ),
  );

  // ---------------------------------------------------------------------------
  // 2. SECONDARY BUTTON (Industrial Amber / Safety Yellow)
  // ---------------------------------------------------------------------------
  static ButtonStyle get secondaryStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.textPrimary,
    disabledBackgroundColor: AppColors.border,
    disabledForegroundColor: AppColors.textDisabled,
    elevation: 0,
    padding: _padding,
    shape: RoundedRectangleBorder(borderRadius: _borderRadius),
    textStyle: AppTypography.buttonLabel.copyWith(
      color: AppColors.textPrimary,
    ),
  );

  // ---------------------------------------------------------------------------
  // 3. DANGER / ERROR BUTTON (Red Alert for critical hazards/deletions)
  // ---------------------------------------------------------------------------
  static ButtonStyle get dangerStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: AppColors.white,
    disabledBackgroundColor: AppColors.border,
    disabledForegroundColor: AppColors.textDisabled,
    elevation: 0,
    padding: _padding,
    shape: RoundedRectangleBorder(borderRadius: _borderRadius),
    textStyle: AppTypography.buttonLabel,
  );

  // ---------------------------------------------------------------------------
  // 4. OUTLINED BUTTON
  // ---------------------------------------------------------------------------
  static OutlinedButtonThemeData get outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.textDisabled,
      padding: _padding,
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      side: const BorderSide(color: AppColors.border, width: 1.5),
      textStyle: AppTypography.buttonLabel.copyWith(
        color: AppColors.textPrimary,
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  // 5. TEXT BUTTON
  // ---------------------------------------------------------------------------
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.textDisabled,
      overlayColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(side: BorderSide.none),
      textStyle: AppTypography.buttonLabel.copyWith(
        color: AppColors.primary,
      ),
    ),
  );
}