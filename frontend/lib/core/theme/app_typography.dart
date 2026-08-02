import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized Typography configuration for the app.
/// Usage: AppTypography.heading1 or Text('Title', style: AppTypography.heading1)
abstract class AppTypography {
  // Base Font Family (using system font or custom Google Font like Inter/Roboto)
  static const String fontFamily = "Manrope";

  // ---------------------------------------------------------------------------
  // Headings (Dashboards, Page Headers, Card Titles)
  // ---------------------------------------------------------------------------

  /// Main Screen Headers (e.g., "Construction Site Dashboard")
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.25,
    letterSpacing: -0.5,
  );

  /// Section Titles (e.g., "Recent Daily Reports", "Open Issues")
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.2,
  );

  /// Sub-section Titles & Modal Headers
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // ---------------------------------------------------------------------------
  // Statistics & Metrics Displays (High Legibility On-Site)
  // ---------------------------------------------------------------------------

  /// Large Metric Numbers on Dashboard Stat Cards (e.g., "14", "98%")
  static const TextStyle statValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Stat Card Sub-labels (e.g., "Active Engineers", "Total Sites")
  static const TextStyle statLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // ---------------------------------------------------------------------------
  // Body Text (Standard Paragraphs, Form Descriptions)
  // ---------------------------------------------------------------------------

  /// Standard Primary Body Text (High Contrast)
  static const TextStyle bodyPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Secondary Body Text for Descriptions, Subtitles & Metadata
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Small Metadata, Timestamps & Captions (e.g., "Reported 2h ago")
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // ---------------------------------------------------------------------------
  // Buttons & Interactive Elements
  // ---------------------------------------------------------------------------

  /// Primary Button Text
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.2,
  );

  /// Badge / Status Pill Text (e.g., "APPROVED", "PENDING")
  static const TextStyle badgeLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  // ---------------------------------------------------------------------------
  // Input Fields & Form Labels
  // ---------------------------------------------------------------------------

  /// Text Field Labels (e.g., "Site Location", "Engineer Name")
  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Form Field Placeholder / Hint Text
  static const TextStyle inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
  );
}