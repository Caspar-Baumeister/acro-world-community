import 'package:acroworld/presentation/components/charts/analytics_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for analytics data
class AnalyticsState {
  final String selectedMetric;
  final bool isLoading;
  final Map<String, List<ChartDataPoint>> chartData;

  const AnalyticsState({
    this.selectedMetric = "page_views",
    this.isLoading = false,
    this.chartData = const {},
  });

  AnalyticsState copyWith({
    String? selectedMetric,
    bool? isLoading,
    Map<String, List<ChartDataPoint>>? chartData,
  }) {
    return AnalyticsState(
      selectedMetric: selectedMetric ?? this.selectedMetric,
      isLoading: isLoading ?? this.isLoading,
      chartData: chartData ?? this.chartData,
    );
  }

  List<ChartDataPoint> get currentChartData => chartData[selectedMetric] ?? [];
  
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

  String get currentValue {
    final data = currentChartData;
    if (data.isEmpty) return "0";
    
    final total = data.map((e) => e.value).reduce((a, b) => a + b);
    switch (selectedMetric) {
      case "page_views":
        return total.toInt().toString();
      case "revenue":
        return "€${total.toStringAsFixed(2)}";
      case "bookings":
        return total.toInt().toString();
      default:
        return total.toString();
    }
  }

  String get currentSubtitle {
    switch (selectedMetric) {
      case "page_views":
        return "Total views this month";
      case "revenue":
        return "Total revenue this month";
      case "bookings":
        return "Total bookings this month";
      default:
        return "This month";
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
  AnalyticsNotifier() : super(const AnalyticsState()) {
    _initializeData();
  }

  void _initializeData() {
    // Generate hardcoded sample data
    final now = DateTime.now();
    final pageViewsData = _generateSampleData(now, 50, 200, "views");
    final revenueData = _generateSampleData(now, 10, 500, "revenue");
    final bookingsData = _generateSampleData(now, 2, 15, "bookings");

    state = state.copyWith(
      chartData: {
        "page_views": pageViewsData,
        "revenue": revenueData,
        "bookings": bookingsData,
      },
    );
  }

  List<ChartDataPoint> _generateSampleData(DateTime now, double min, double max, String type) {
    final data = <ChartDataPoint>[];
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final randomValue = min + (max - min) * (0.5 + 0.5 * (i % 3 - 1) / 2);
      
      data.add(ChartDataPoint(
        label: _getDayLabel(date),
        value: randomValue,
        date: date,
      ));
    }
    
    return data;
  }

  String _getDayLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    return _getWeekdayName(date.weekday);
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return "Mon";
      case 2: return "Tue";
      case 3: return "Wed";
      case 4: return "Thu";
      case 5: return "Fri";
      case 6: return "Sat";
      case 7: return "Sun";
      default: return "Day";
    }
  }

  void updateSelectedMetric(String metric) {
    state = state.copyWith(selectedMetric: metric);
  }
}

/// Provider for analytics state
final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier();
});
