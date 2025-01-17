import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ModelPieChart extends StatelessWidget {
  final List<String> modelNames; // List with possible duplicate names

  const ModelPieChart({super.key, required this.modelNames});

  static const List<Color> _colorPalette = <Color>[
    Color(0xFF6C5B7B), // Mauve
    Color(0xFF355C7D), // Deep Blue
    Color(0xFF99B898), // Light Green
    Color(0xFFFECEA8), // Soft Orange
    Color(0xFFFF847C), // Coral
    Color(0xFF2A363B), // Charcoal Gray
    Color(0xFFF8B195), // Blush Pink
    Color(0xFF92A8D1), // Pastel Blue
  ];

  @override
  Widget build(BuildContext context) {
    final data = _calculateData(); // Calculate summed data

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

  /// Counts occurrences of each name in [modelNames] and returns a map.
  Map<String, double> _calculateData() {
    final Map<String, double> dataMap = {};
    for (var name in modelNames) {
      if (dataMap.containsKey(name)) {
        dataMap[name] = dataMap[name]! + 1;
      } else {
        dataMap[name] = 1;
      }
    }
    return dataMap;
  }

  /// Generates pie chart sections with percentage values.
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
        color: _colorPalette[
            data.keys.toList().indexOf(name) % _colorPalette.length],
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        titleStyle: Theme.of(context).textTheme.labelMedium,
        radius: 50,
      );
    }).toList();
  }

  /// Builds a legend based on the same colors used in the pie chart.
  Widget _buildLegend(Map<String, double> data, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: data.entries.map((entry) {
        final name = entry.key;
        final color = _colorPalette[
            data.keys.toList().indexOf(name) % _colorPalette.length];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              name,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        );
      }).toList(),
    );
  }
}
