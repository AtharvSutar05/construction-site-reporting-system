import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF1E3A8A);   // Deep Industrial Navy
  static const Color secondary = Color(0xFFF59E0B); // Safety Amber/Yellow

  // Status Colors
  static const Color success = Color(0xFF10B981);   // Green
  static const Color warning = Color(0xFFF97316);   // Orange
  static const Color error = Color(0xFFEF4444);     // Red
  static const Color info = Color(0xFF0284C7);      // Sky Blue

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC); // Light Concrete Tint
  static const Color surface = Color(0xFFFFFFFF);    // Pure White

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);     // Slate Border

  // Typography
  static const Color textPrimary = Color(0xFF0F172A);   // Dark Charcoal
  static const Color textSecondary = Color(0xFF64748B); // Slate Gray
  static const Color textDisabled = Color(0xFF94A3B8);  // Light Slate

  // Basics
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
}