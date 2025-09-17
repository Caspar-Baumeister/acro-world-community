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
          onPeriodChanged: (period) =>
              analyticsNotifier.updateSelectedTimePeriod(period),
        ),

        // Analytics Chart
        _buildAnalyticsChart(ref, analyticsState),

        // Filter Section
        AnalyticsFilterSection(
          selectedMetric: analyticsState.selectedMetric,
          onMetricChanged: (metric) =>
              analyticsNotifier.updateSelectedMetric(metric),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAnalyticsChart(WidgetRef ref, AnalyticsState analyticsState) {
    switch (analyticsState.selectedMetric) {
      case "page_views":
        return ref
            .watch(
                pageViewsAnalyticsProvider(analyticsState.selectedTimePeriod))
            .when(
              data: (dataPoints) => _buildChart(analyticsState, dataPoints),
              loading: () => _buildLoadingChart(analyticsState),
              error: (error, stack) =>
                  _buildErrorChart(analyticsState, error.toString()),
            );
      case "revenue":
        return ref
            .watch(revenueAnalyticsProvider(analyticsState.selectedTimePeriod))
            .when(
              data: (dataPoints) => _buildChart(analyticsState, dataPoints),
              loading: () => _buildLoadingChart(analyticsState),
              error: (error, stack) =>
                  _buildErrorChart(analyticsState, error.toString()),
            );
      case "bookings":
        return ref
            .watch(bookingsAnalyticsProvider(analyticsState.selectedTimePeriod))
            .when(
              data: (dataPoints) => _buildChart(analyticsState, dataPoints),
              loading: () => _buildLoadingChart(analyticsState),
              error: (error, stack) =>
                  _buildErrorChart(analyticsState, error.toString()),
            );
      default:
        return _buildChart(analyticsState, []);
    }
  }

  Widget _buildChart(
      AnalyticsState analyticsState, List<ChartDataPoint> dataPoints) {
    final total = dataPoints.isEmpty
        ? 0.0
        : dataPoints.map((e) => e.value).reduce((a, b) => a + b);
    final value = _formatValue(total, analyticsState.selectedMetric);
    final ticks = _buildTicks(analyticsState.selectedTimePeriod, dataPoints);

    return AnalyticsChart(
      title: analyticsState.currentTitle,
      value: value,
      subtitle: analyticsState.currentSubtitle,
      dataPoints: dataPoints,
      primaryColor: analyticsState.currentColor,
      xTicks: ticks,
    );
  }

  List<AxisTick> _buildTicks(String period, List<ChartDataPoint> points) {
    if (points.isEmpty) return [];
    final n = points.length - 1;
    double posAtIndex(int idx) => n == 0 ? 0.0 : idx / n;

    switch (period) {
      case 'today':
      case 'yesterday':
        // 4 ticks at indices representing 12 AM, 8 AM, 4 PM, 12 PM over a 24h scale → positions 0, 8/24, 16/24, 12/24
        // Show last label at the end of the axis (1.0) instead of midpoint
        return [
          AxisTick(position: 0.0, label: '12 AM'),
          AxisTick(position: 8 / 24, label: '8 AM'),
          AxisTick(position: 16 / 24, label: '4 PM'),
          AxisTick(position: 1.0, label: '12 PM'),
        ];
      case 'last_7_days':
        // 7 ticks for each day label already in points
        return List.generate(points.length,
            (i) => AxisTick(position: posAtIndex(i), label: points[i].label));
      case 'last_30_days':
        // 6 ticks evenly spaced: indices 0,6,12,18,24,30
        final indices = [0, 6, 12, 18, 24, 30].where((i) => i <= n).toList();
        return indices
            .map((i) =>
                AxisTick(position: posAtIndex(i), label: points[i].label))
            .toList();
      case 'this_month':
        // 1,7,14,21,last
        final idx1 = 0;
        final idx7 = points.length > 6 ? 6 : n;
        final idx14 = points.length > 13 ? 13 : n;
        final idx21 = points.length > 20 ? 20 : n;
        final idxLast = n;
        final indices = {idx1, idx7, idx14, idx21, idxLast}.toList()..sort();
        return indices
            .map((i) =>
                AxisTick(position: posAtIndex(i), label: points[i].label))
            .toList();
      case 'this_year':
        // Jan, Apr, Jul, Oct, Dec → indices 0,3,6,9,11 if available
        final base = [0, 3, 6, 9, 11].where((i) => i <= n).toList();
        return base
            .map((i) =>
                AxisTick(position: posAtIndex(i), label: points[i].label))
            .toList();
      case 'all_time':
        // 4 evenly spaced year ticks
        final count = 4;
        return List.generate(count, (i) {
          final idx = ((n) * (i / (count - 1))).round();
          return AxisTick(position: posAtIndex(idx), label: points[idx].label);
        });
      default:
        return [];
    }
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
