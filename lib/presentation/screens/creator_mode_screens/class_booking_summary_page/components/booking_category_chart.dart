import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BookingCategoryChart extends StatelessWidget {
  const BookingCategoryChart({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  // Better colors for booking categories
  static const List<Color> _categoryColors = <Color>[
    Color(0xFF4CAF50), // Green for Base
    Color(0xFF2196F3), // Blue for Intermediate
    Color(0xFFFF9800), // Orange for Advanced
    Color(0xFF9C27B0), // Purple for Expert
    Color(0xFFF44336), // Red for Pro
    Color(0xFF607D8B), // Blue Grey for Other
    Color(0xFF795548), // Brown for Special
    Color(0xFFE91E63), // Pink for Custom
  ];

  @override
  Widget build(BuildContext context) {
    final data = _calculateCategoryData();

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: _generateSections(context, data),
              sectionsSpace: 2,
              centerSpaceRadius: 20,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        _buildLegend(data, context),
      ],
    );
  }

  /// Calculate booking category data
  Map<String, double> _calculateCategoryData() {
    final Map<String, double> dataMap = {};
    
    for (var booking in bookings) {
      String categoryName = "Not Specified";
      
      final bookingOption = booking.bookingOption;
      if (bookingOption?.bookingCategory?.name != null) {
        categoryName = bookingOption!.bookingCategory!.name!;
      } else if (bookingOption?.title != null) {
        categoryName = bookingOption!.title!;
      }
      
      dataMap[categoryName] = (dataMap[categoryName] ?? 0) + 1;
    }
    
    return dataMap;
  }

  /// Generates pie chart sections with percentage values
  List<PieChartSectionData> _generateSections(
    BuildContext context,
    Map<String, double> data,
  ) {
    final double total = data.values.reduce((a, b) => a + b);

    return data.entries.map((entry) {
      final name = entry.key;
      final count = entry.value;
      final percentage = (count / total) * 100;

      return PieChartSectionData(
        color: _categoryColors[
            data.keys.toList().indexOf(name) % _categoryColors.length],
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        radius: 50,
      );
    }).toList();
  }

  /// Builds a legend based on the same colors used in the pie chart
  Widget _buildLegend(Map<String, double> data, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: data.entries.map((entry) {
        final name = entry.key;
        final color = _categoryColors[
            data.keys.toList().indexOf(name) % _categoryColors.length];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}