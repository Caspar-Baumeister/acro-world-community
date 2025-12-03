/// Centralized dimensions following the AcroWorld Style Guide
/// Use these constants instead of hardcoded values for consistency
class AppDimensions {
  // ============================================
  // SPACING (following 4-point grid system)
  // ============================================

  /// Extra small spacing: 4.0 - for tight elements or internal padding
  static const double spacingExtraSmall = 4.0;

  /// Small spacing: 8.0 - for elements within a group
  static const double spacingSmall = 8.0;

  /// Medium spacing: 16.0 - standard spacing between major UI elements
  static const double spacingMedium = 16.0;

  /// Large spacing: 24.0 - for section separation
  static const double spacingLarge = 24.0;

  /// Extra large spacing: 32.0 - for significant content breaks
  static const double spacingExtraLarge = 32.0;

  /// Huge spacing: 48.0 - for major section breaks
  static const double spacingHuge = 48.0;

  // ============================================
  // BORDER RADIUS
  // ============================================

  /// Small radius: 4.0 - for chips, small buttons
  static const double radiusSmall = 4.0;

  /// Medium radius: 8.0 - for input fields, standard components
  static const double radiusMedium = 8.0;

  /// Large radius: 12.0 - for cards, containers
  static const double radiusLarge = 12.0;

  /// Extra large radius: 16.0 - for prominent elements
  static const double radiusExtraLarge = 16.0;

  /// Full/circular radius: 999.0 - for avatars, FABs
  static const double radiusFull = 999.0;

  // ============================================
  // ELEVATION
  // ============================================

  /// No elevation
  static const double elevationNone = 0.0;

  /// Small elevation: 2.0 - for subtle lift
  static const double elevationSmall = 2.0;

  /// Medium elevation: 4.0 - for cards
  static const double elevationMedium = 4.0;

  /// Large elevation: 8.0 - for modals, FABs
  static const double elevationLarge = 8.0;

  // ============================================
  // ICON SIZES
  // ============================================

  /// Tiny icon: 16.0 - for inline indicators
  static const double iconSizeTiny = 16.0;

  /// Small icon: 24.0 - standard icon size
  static const double iconSizeSmall = 24.0;

  /// Medium icon: 32.0 - for prominent features
  static const double iconSizeMedium = 32.0;

  /// Large icon: 40.0 - for app bar, important features
  static const double iconSizeLarge = 40.0;

  /// Extra large icon: 48.0 - for dialogs, empty states
  static const double iconSizeExtraLarge = 48.0;

  /// Dialog icon size: 48.0 - alias for iconSizeExtraLarge
  static const double iconSizeDialog = 48.0;

  // ============================================
  // COMPONENT HEIGHTS
  // ============================================

  /// Standard button height: 48.0
  static const double buttonHeight = 48.0;

  /// Small button height: 36.0
  static const double buttonHeightSmall = 36.0;

  /// Large button height: 56.0
  static const double buttonHeightLarge = 56.0;

  /// Standard input field height: 56.0
  static const double inputHeight = 56.0;

  /// App bar height: 56.0
  static const double appBarHeight = 56.0;

  /// Expanded app bar height: 200.0
  static const double appBarExpandedHeight = 200.0;

  /// App bar collapsed threshold for animations: 0.5
  static const double appBarCollapsedThreshold = 0.5;

  /// Bottom navigation bar height (approx)
  static const double bottomNavHeight = 80.0;

  // ============================================
  // AVATAR SIZES
  // ============================================

  /// Small avatar: 32.0
  static const double avatarSizeSmall = 32.0;

  /// Medium avatar: 48.0
  static const double avatarSizeMedium = 48.0;

  /// Large avatar: 72.0
  static const double avatarSizeLarge = 72.0;

  /// Extra large avatar: 96.0 - for profile headers
  static const double avatarSizeExtraLarge = 96.0;

  // ============================================
  // CARD DIMENSIONS
  // ============================================

  /// Standard card height for lists: 120.0
  static const double cardHeightSmall = 120.0;

  /// Medium card height: 160.0
  static const double cardHeightMedium = 160.0;

  /// Discovery card width: 200.0
  static const double cardWidthDiscovery = 200.0;

  /// Discovery card height: 260.0
  static const double cardHeightDiscovery = 260.0;

  // ============================================
  // TOUCH TARGETS
  // ============================================

  /// Minimum touch target size (accessibility): 48.0
  static const double minTouchTarget = 48.0;
}
