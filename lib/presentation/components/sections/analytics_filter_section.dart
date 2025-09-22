import 'package:acroworld/presentation/components/filters/modern_filter_chip.dart';
import 'package:flutter/material.dart';

class AnalyticsFilterSection extends StatelessWidget {
  final String selectedMetric;
  final ValueChanged<String> onMetricChanged;

  const AnalyticsFilterSection({
    super.key,
    required this.selectedMetric,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Order: Revenue, Bookings, Page Views (last)
            ModernFilterChip(
              label: "Revenue",
              isSelected: selectedMetric == "revenue",
              onTap: () => onMetricChanged("revenue"),
              icon: Icons.attach_money,
            ),
            const SizedBox(width: 8),
            ModernFilterChip(
              label: "Bookings",
              isSelected: selectedMetric == "bookings",
              onTap: () => onMetricChanged("bookings"),
              icon: Icons.event,
            ),
            const SizedBox(width: 8),
            ModernFilterChip(
              label: "Page Views",
              isSelected: selectedMetric == "page_views",
              onTap: () => onMetricChanged("page_views"),
              icon: Icons.visibility,
            ),
          ],
        ),
      ),
    );
  }
}
