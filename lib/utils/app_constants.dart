// ignore_for_file: constant_identifier_names

/// App-wide constants for business logic and configuration
class AppConstants {
  // App behavior settings
  static const int inAppMessageTime = 2;
  static const double maxRadius = 300;
  static const int activeFlaggThreshold = 1;
  static const int daysUntilCreateNextJam = 7;

  // External URLs
  static const String agbUrl = 'https://acroworld.de/tac';
  static const String playStoreLink =
      'https://play.google.com/store/apps/details?id=com.community.acroworld';
  static const String iosStoreLink = 'https://apps.apple.com/us/app/acroworld';
}

/// Component-specific dimensions that don't belong in generic AppDimensions
/// These are specific to certain UI components and their layouts
class ComponentDimensions {
  // Card heights
  static const double classCardHeight = 135;
  static const double bookingCardHeight = 100;
  static const double classCardTeacherHeight = 30;

  // Difficulty level badge
  static const double difficultyLevelHeight = 22;
  static const double difficultyLevelWidth = 66;

  // Participant button
  static const double participantButtonHeight = 34;
  static const double participantButtonWidth = 150;
}
