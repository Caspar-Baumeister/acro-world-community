// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppConstants {
  static const int inAppMessageTime = 2;
  static const double maxRadius = 300;
  static const int activeFlaggThreshold = 1;
}

class AspectRatios {
  static const ar_21_9 = 21 / 9;
  static const ar_1_1 = 1 / 1;
  static const ar_9_16 = 9 / 16;
  static const ar_26_9 = 26 / 9;
  static const ar_19_9 = 19 / 9;
  static const ar_1_2 = 1 / 2;
  static const ar_6_5 = 7 / 5;
}

class AppDimensions {
  static const double bottomNavBarHeight = 100.0;
  static const double iconSizeTiny = 14;
  static const double iconSizeSmall = 20;

  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 36.0;
  static const double avatarSizeMedium = 45;
  static const double eventDashboardSliderWidth = 150;
  static const double eventVerticalScrollCardHeight = 135;
}

class AppPaddings {
  static const double tiny = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
  static const double toLarge = 64.0;
}

class AppBorders {
  static BorderRadius smallRadius = BorderRadius.circular(10.0);
  static BorderRadius defaultRadius = BorderRadius.circular(20.0);
}

const double appBarExpandedHeight = 200.0;
const double appBarCollapsedThreshold = 0.5;

const double CLASS_CARD_HEIGHT = 135;
const double BOOKING_CARD_HEIGHT = 100;
const double CLASS_CARD_TEACHER_HEIGHT = 30;
const double DIFFICULTY_LEVEL_HEIGHT = 22;
const double DIFFICULTY_LEVEL_WIDTH = 66;
const double PARTICIPANT_BUTTON_HEIGHT = 34;
const double PARTICIPANT_BUTTON_WIDTH = 150;
const double STANDART_ROUNDNESS_STRONG = 20;
const double STANDART_ROUNDNESS_LIGHT = 15;
const double EVENT_DASHBOARD_SLIDER_WIDTH = 250;
const double EVENT_DASHBOARD_SLIDER_HEIGHT = 280;
const double INPUTFIELD_HEIGHT = 50;

const int DAYS_UNTIL_CREATE_NEXT_JAM = 7;

String AGB_URL = 'https://acroworld.de/tac';

const double STANDART_BUTTON_WIDTH = 300;

const String PLAY_STORE_LINK =
    "https://play.google.com/store/apps/details?id=com.community.acroworld";

const String IOS_STORE_LINK = "https://apps.apple.com/us/app/acroworld";
