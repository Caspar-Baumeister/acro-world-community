import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AcroLevelChart extends StatelessWidget {
  const AcroLevelChart({super.key, required this.bookings});

  final List<ClassEventBooking> bookings;

  // Better colors for acro levels - more vibrant and distinct
  static const List<Color> _levelColors = <Color>[
    Color(0xFF4CAF50), // Green for Beginner
    Color(0xFF8BC34A), // Light Green for Novice
    Color(0xFFCDDC39), // Lime for Intermediate
    Color(0xFFFFEB3B), // Yellow for Advanced
    Color(0xFFFF9800), // Orange for Expert
    Color(0xFFFF5722), // Deep Orange for Pro
    Color(0xFFE91E63), // Pink for Master
    Color(0xFF9C27B0), // Purple for Elite
  ];

  @override
  Widget build(BuildContext context) {
    final data = _calculateLevelData();

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

  /// Calculate acro level data
  Map<String, double> _calculateLevelData() {
    final Map<String, double> dataMap = {};
    
    for (var booking in bookings) {
      String levelName = "Not Specified";
      
      if (booking.user.level?.name != null) {
        levelName = booking.user.level!.name!;
      }
      
      dataMap[levelName] = (dataMap[levelName] ?? 0) + 1;
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
        color: _levelColors[
            data.keys.toList().indexOf(name) % _levelColors.length],
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
        final color = _levelColors[
            data.keys.toList().indexOf(name) % _levelColors.length];

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
