import 'package:flutter/material.dart';

// Define core color values here.
// These will be used to construct ColorScheme and AppCustomColors.
class AppColors {
  // Light Theme Base Colors - Modern and improved
  static const Color lightPrimary = Color(0xFF2563EB); // Modern blue primary
  static const Color lightPrimaryDark = Color(0xFF1D4ED8); // Darker blue
  static const Color lightPrimaryDarker = Color(0xFF1E40AF); // Even darker blue
  static const Color lightSecondary = Color(0xFF7C3AED); // Purple secondary
  static const Color lightAccent = Color(0xFFF59E0B); // Amber accent

  static const Color lightBackground = Color(0xFFFAFAFA); // Slightly warmer white
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightText = Color(0xFF1F2937); // Darker, more readable text
  static const Color lightTextMuted = Color(0xFF6B7280); // Better contrast muted text
  static const Color lightTextStrong = Color(0xFF111827); // Stronger text color
  static const Color lightBorders = Color(0xFFE5E7EB); // Softer borders
  static const Color lightError = Color(0xFFDC2626); // Modern red
  static const Color lightWarning = Color(0xFFD97706); // Modern orange
  static const Color lightSuccess = Color(0xFF059669); // Modern green
  static const Color lightIcon = Color(0xFF374151); // Better icon color
  static const Color lightFocus = Color(0xFFF59E0B); // Same as lightAccent

  // Dark Theme Base Colors - Modern and improved
  static const Color darkPrimary = Color(0xFF3B82F6); // Brighter blue for dark theme
  static const Color darkPrimaryLight = Color(0xFF60A5FA); // Lighter blue
  static const Color darkPrimaryLighter = Color(0xFF93C5FD); // Even lighter blue
  static const Color darkSecondary = Color(0xFF8B5CF6); // Purple secondary
  static const Color darkAccent = Color(0xFFFBBF24); // Brighter amber

  static const Color darkBackground = Color(0xFF0F172A); // Modern dark background
  static const Color darkSurface = Color(0xFF1E293B); // Modern dark surface
  static const Color darkText = Color(0xFFF8FAFC); // Clean white text
  static const Color darkTextMuted = Color(0xFF94A3B8); // Better contrast muted text
  static const Color darkTextStrong = Color(0xFFFFFFFF); // Pure white for strong text
  static const Color darkBorders = Color(0xFF334155); // Modern dark borders
  static const Color darkError = Color(0xFFEF4444); // Modern red
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