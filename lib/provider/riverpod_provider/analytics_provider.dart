import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for analytics data
class AnalyticsState {
  final String selectedMetric;
  final String selectedTimePeriod;
  final bool isLoading;

  const AnalyticsState({
    this.selectedMetric = "page_views",
    this.selectedTimePeriod = "last_7_days",
    this.isLoading = false,
  });

  AnalyticsState copyWith({
    String? selectedMetric,
    String? selectedTimePeriod,
    bool? isLoading,
  }) {
    return AnalyticsState(
      selectedMetric: selectedMetric ?? this.selectedMetric,
      selectedTimePeriod: selectedTimePeriod ?? this.selectedTimePeriod,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  String get currentTitle {
    switch (selectedMetric) {
      case "page_views":
        return "Page Views";
      case "revenue":
        return "Revenue";
      case "bookings":
        return "Bookings";
      default:
        return "Analytics";
    }
  }

  String get currentSubtitle {
    switch (selectedTimePeriod) {
      case "today":
        return "Today";
      case "yesterday":
        return "Yesterday";
      case "last_7_days":
        return "Last 7 days";
      case "last_30_days":
        return "Last 30 days";
      case "this_month":
        return "This month";
      case "this_year":
        return "This year";
      case "all_time":
        return "All time";
      default:
        return "Last 7 days";
    }
  }

  Color get currentColor {
    switch (selectedMetric) {
      case "page_views":
        return Colors.blue;
      case "revenue":
        return Colors.green;
      case "bookings":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

/// Notifier for analytics state management
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier() : super(const AnalyticsState());

  void updateSelectedMetric(String metric) {
    state = state.copyWith(selectedMetric: metric);
  }

  void updateSelectedTimePeriod(String timePeriod) {
    state = state.copyWith(selectedTimePeriod: timePeriod);
  }
}

/// Provider for analytics state
final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier();
});
