import 'package:acroworld/presentation/components/charts/analytics_chart.dart';
import 'package:acroworld/presentation/components/sections/analytics_filter_section.dart';
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
        // Analytics Chart
        AnalyticsChart(
          title: analyticsState.currentTitle,
          value: analyticsState.currentValue,
          subtitle: analyticsState.currentSubtitle,
          dataPoints: analyticsState.currentChartData,
          primaryColor: analyticsState.currentColor,
        ),
        
        // Filter Section
        AnalyticsFilterSection(
          selectedMetric: analyticsState.selectedMetric,
          onMetricChanged: (metric) => analyticsNotifier.updateSelectedMetric(metric),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }
}
