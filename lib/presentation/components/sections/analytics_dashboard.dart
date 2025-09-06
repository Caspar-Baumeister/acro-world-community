import 'package:acroworld/presentation/components/charts/analytics_chart.dart';
import 'package:acroworld/presentation/components/input/time_period_dropdown.dart';
import 'package:acroworld/presentation/components/sections/analytics_filter_section.dart';
import 'package:acroworld/provider/riverpod_provider/analytics_api_provider.dart';
import 'package:acroworld/provider/riverpod_provider/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsDashboard extends ConsumerWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsProvider);
    final analyticsNotifier = ref.read(analyticsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Period Dropdown
        TimePeriodDropdown(
          selectedPeriod: analyticsState.selectedTimePeriod,
          onPeriodChanged: (period) => analyticsNotifier.updateSelectedTimePeriod(period),
        ),
        
        // Analytics Chart
        _buildAnalyticsChart(ref, analyticsState),
        
        // Filter Section
        AnalyticsFilterSection(
          selectedMetric: analyticsState.selectedMetric,
          onMetricChanged: (metric) => analyticsNotifier.updateSelectedMetric(metric),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAnalyticsChart(WidgetRef ref, AnalyticsState analyticsState) {
    switch (analyticsState.selectedMetric) {
      case "page_views":
        return ref.watch(pageViewsAnalyticsProvider(analyticsState.selectedTimePeriod)).when(
          data: (dataPoints) => _buildChart(analyticsState, dataPoints),
          loading: () => _buildLoadingChart(analyticsState),
          error: (error, stack) => _buildErrorChart(analyticsState, error.toString()),
        );
      case "revenue":
        return ref.watch(revenueAnalyticsProvider(analyticsState.selectedTimePeriod)).when(
          data: (dataPoints) => _buildChart(analyticsState, dataPoints),
          loading: () => _buildLoadingChart(analyticsState),
          error: (error, stack) => _buildErrorChart(analyticsState, error.toString()),
        );
      case "bookings":
        return ref.watch(bookingsAnalyticsProvider(analyticsState.selectedTimePeriod)).when(
          data: (dataPoints) => _buildChart(analyticsState, dataPoints),
          loading: () => _buildLoadingChart(analyticsState),
          error: (error, stack) => _buildErrorChart(analyticsState, error.toString()),
        );
      default:
        return _buildChart(analyticsState, []);
    }
  }

  Widget _buildChart(AnalyticsState analyticsState, List<ChartDataPoint> dataPoints) {
    final total = dataPoints.isEmpty ? 0.0 : dataPoints.map((e) => e.value).reduce((a, b) => a + b);
    final value = _formatValue(total, analyticsState.selectedMetric);
    
    return AnalyticsChart(
      title: analyticsState.currentTitle,
      value: value,
      subtitle: analyticsState.currentSubtitle,
      dataPoints: dataPoints,
      primaryColor: analyticsState.currentColor,
    );
  }

  Widget _buildLoadingChart(AnalyticsState analyticsState) {
    return AnalyticsChart(
      title: analyticsState.currentTitle,
      value: "Loading...",
      subtitle: analyticsState.currentSubtitle,
      dataPoints: [],
      primaryColor: analyticsState.currentColor,
    );
  }

  Widget _buildErrorChart(AnalyticsState analyticsState, String error) {
    return AnalyticsChart(
      title: analyticsState.currentTitle,
      value: "Error",
      subtitle: error,
      dataPoints: [],
      primaryColor: analyticsState.currentColor,
    );
  }

  String _formatValue(double total, String metric) {
    switch (metric) {
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
}
