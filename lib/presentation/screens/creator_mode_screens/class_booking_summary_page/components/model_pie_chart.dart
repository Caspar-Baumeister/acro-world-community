import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ModelPieChart extends StatelessWidget {
  final List<String> modelNames; // List with possible duplicate names

  const ModelPieChart({super.key, required this.modelNames});

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

  Map<String, double> _calculateData() {
    // Count occurrences of each name
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

  List<PieChartSectionData> _generateSections(
      BuildContext context, Map<String, double> data) {
    // Calculate total count
    final double total = data.values.reduce((a, b) => a + b);

    // Generate pie sections with percentage values
    return data.entries.map((entry) {
      final name = entry.key;
      final count = entry.value;
      final percentage = (count / total) * 100;

      return PieChartSectionData(
        color: Colors.primaries[
            data.keys.toList().indexOf(name) % Colors.primaries.length],
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        titleStyle: Theme.of(context).textTheme.labelMedium,
        radius: 50,
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> data, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: data.entries.map((entry) {
        final name = entry.key;
        final color = Colors.primaries[
            data.keys.toList().indexOf(name) % Colors.primaries.length];

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
