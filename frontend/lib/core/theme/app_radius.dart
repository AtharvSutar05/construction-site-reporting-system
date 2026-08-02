import 'package:flutter/material.dart';

abstract class AppRadius {
  // ---------------------------------------------------------------------------
  // Raw Radius Values (double)
  // ---------------------------------------------------------------------------
  static const double xsValue = 4.0;
  static const double smValue = 8.0;
  static const double mdValue = 12.0;
  static const double lgValue = 16.0;
  static const double xlValue = 24.0;
  static const double fullValue = 999.0;

  // ---------------------------------------------------------------------------
  // Pre-built BorderRadius Objects
  // ---------------------------------------------------------------------------

  /// Extra Small (4px) - Badges, small status pills, tags
  static const BorderRadius xs = BorderRadius.all(Radius.circular(xsValue));

  /// Small (8px) - Buttons, text input fields, tooltips
  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));

  /// Medium (12px) - Standard Cards, Action Dialogs, Alert Boxes
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));

  /// Large (16px) - Bottom Sheets, Main Containers, Dashboard Sections
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));

  /// Extra Large (24px) - Floating Modals, Drawer edges
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));

  /// Pill / Circular (999px) - Avatars, Rounded Action Badges
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullValue));

  // ---------------------------------------------------------------------------
  // Asymmetrical Radius Helpers (e.g., Bottom Sheets, Side Drawers)
  // ---------------------------------------------------------------------------

  /// Top-only rounded corners (For Modal Bottom Sheets)
  static const BorderRadius topMd = BorderRadius.only(
    topLeft: Radius.circular(mdValue),
    topRight: Radius.circular(mdValue),
  );

  static const BorderRadius topLg = BorderRadius.only(
    topLeft: Radius.circular(lgValue),
    topRight: Radius.circular(lgValue),
  );
}