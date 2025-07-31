import 'package:flutter/material.dart';

// Define core color values here.
// These will be used to construct ColorScheme and AppCustomColors.
class AppColors {
  // Light Theme Base Colors
  static const Color lightPrimary = Color(0xFF606c38); // Primary
  static const Color lightPrimaryDark = Color(0xFF4a542c); // Derived from Primary
  static const Color lightPrimaryDarker = Color(0xFF353d1f); // Derived from Primary
  static const Color lightSecondary = Color(0xFF03071e); // Secondary
  static const Color lightAccent = Color(0xFFffba08); // Accent

  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF424242);
  static const Color lightTextMuted = Color(0xFF9E9E9E);
  static const Color lightTextStrong = Color(0xFF424242); // Same as lightText
  static const Color lightBorders = Color(0xFFE0E0E0);
  static const Color lightError = Color(0xFFE53935);
  static const Color lightWarning = Color(0xFF8B0000);
  static const Color lightSuccess = Color(0xFF66BB6A);
  static const Color lightIcon = Color(0xFF424242);
  static const Color lightFocus = Color(0xFFffba08); // Same as lightAccent

  // Dark Theme Base Colors
  static const Color darkPrimary = Color(0xFF606c38); // Primary
  static const Color darkPrimaryLight = Color(0xFF7a8b4a); // Derived from Primary
  static const Color darkPrimaryLighter = Color(0xFF94a75c); // Derived from Primary
  static const Color darkSecondary = Color(0xFF03071e); // Secondary
  static const Color darkAccent = Color(0xFFffba08); // Accent

  static const Color darkBackground = Color(0xFF212121);
  static const Color darkSurface = Color(0xFF424242);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextMuted = Color(0xFFBDBDBD);
  static const Color darkTextStrong = Color(0xFFFFFFFF); // Same as darkText
  static const Color darkBorders = Color(0xFF616161);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkWarning = Color(0xFF8B0000);
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkIcon = Color(0xFFFFFFFF);
  static const Color darkFocus = Color(0xFFffba08); // Same as darkAccent

  // General Utility Colors (if not theme-dependent)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF66BB6A);
  static const Color orange = Color(0xFFffba08);
}