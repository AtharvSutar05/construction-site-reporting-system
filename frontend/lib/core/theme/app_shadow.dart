import 'package:flutter/material.dart';

abstract class AppShadow {
  /// Base shadow color (Slate / Charcoal)
  static const Color _shadowColor = Color(0xFF0F172A);

  // ---------------------------------------------------------------------------
  // Shadow Levels (Using modern `withValues(alpha: ...)` instead of `withOpacity`)
  // ---------------------------------------------------------------------------

  /// Low Elevation - Site Cards, List Items
  static final List<BoxShadow> sm = [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.04),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.02),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  /// Medium Elevation - Active Cards, Hovered States, Dropdowns
  static final List<BoxShadow> md = [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.06),
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.04),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  /// High Elevation - Floating Action Buttons, Navigation Drawers
  static final List<BoxShadow> lg = [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.08),
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.04),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  /// Extra High Elevation - Dialogs, Alert Modals
  static final List<BoxShadow> xl = [
    BoxShadow(
      color: _shadowColor.withValues(alpha: 0.12),
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
  ];
}