import 'package:flutter/material.dart';

class AnalyticsChart extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final List<ChartDataPoint> dataPoints;
  final Color primaryColor;

  const AnalyticsChart({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.dataPoints,
    this.primaryColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForTitle(title),
                  color: primaryColor,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart with axes
          SizedBox(
            height: 180,
            child: _buildChartWithAxes(context, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildChartWithAxes(BuildContext context, ColorScheme colorScheme) {
    if (dataPoints.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    final maxValue =
        dataPoints.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue = 0.0; // Always start y-axis at 0

    // If all values are 0, set a reasonable range for better visualization
    final adjustedMaxValue = maxValue == 0.0 ? 10.0 : maxValue;
    final range = adjustedMaxValue - minValue;

    return CustomPaint(
      painter: _ChartWithAxesPainter(
        dataPoints: dataPoints,
        maxValue: adjustedMaxValue,
        minValue: minValue,
        range: range,
        primaryColor: primaryColor,
        colorScheme: colorScheme,
      ),
      size: Size.infinite,
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'page views':
        return Icons.visibility;
      case 'revenue':
        return Icons.attach_money;
      case 'bookings':
        return Icons.event;
      default:
        return Icons.analytics;
    }
  }
}

class ChartDataPoint {
  final String label;
  final double value;
  final DateTime date;

  ChartDataPoint({
    required this.label,
    required this.value,
    required this.date,
  });
}

class _ChartWithAxesPainter extends CustomPainter {
  final List<ChartDataPoint> dataPoints;
  final double maxValue;
  final double minValue;
  final double range;
  final Color primaryColor;
  final ColorScheme colorScheme;

  _ChartWithAxesPainter({
    required this.dataPoints,
    required this.maxValue,
    required this.minValue,
    required this.range,
    required this.primaryColor,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = colorScheme.outline.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Chart area with margins for axes
    final chartLeft = 40.0;
    final chartRight = size.width - 10.0;
    final chartTop = 10.0;
    final chartBottom = size.height - 30.0;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    // Draw Y-axis
    canvas.drawLine(
      Offset(chartLeft, chartTop),
      Offset(chartLeft, chartBottom),
      axisPaint,
    );

    // Draw X-axis
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );

    // Draw Y-axis labels with smart step calculation
    final ySteps = _calculateOptimalSteps(maxValue);
    final Set<String> usedLabels = {}; // Track used labels to avoid duplicates

    for (int i = 0; i <= ySteps; i++) {
      final value = minValue + (range * i / ySteps);
      final y = chartBottom - (i * chartHeight / ySteps);

      // Round the value to get clean step numbers
      final roundedValue = _roundToNiceNumber(value);
      final label = _formatValue(roundedValue);

      // Skip if we've already used this label
      if (usedLabels.contains(label)) continue;
      usedLabels.add(label);

      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    // Draw X-axis labels
    for (int i = 0; i < dataPoints.length; i++) {
      final x = chartLeft + (i * chartWidth / (dataPoints.length - 1));

      textPainter.text = TextSpan(
        text: dataPoints[i].label,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartBottom + 5),
      );
    }

    // Draw chart
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final x = chartLeft + (i * chartWidth / (dataPoints.length - 1));

      // If all values are 0, position line at the bottom (y-axis = 0)
      final normalizedValue = point.value == 0.0 && maxValue == 0.0
          ? 0.0
          : (range > 0 ? (point.value - minValue) / range : 0.5);
      final y = chartBottom - (normalizedValue * chartHeight);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartBottom);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Close the fill path
    fillPath.lineTo(chartRight, chartBottom);
    fillPath.close();

    // Draw fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final x = chartLeft + (i * chartWidth / (dataPoints.length - 1));

      // If all values are 0, position points at the bottom (y-axis = 0)
      final normalizedValue = point.value == 0.0 && maxValue == 0.0
          ? 0.0
          : (range > 0 ? (point.value - minValue) / range : 0.5);
      final y = chartBottom - (normalizedValue * chartHeight);

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  int _calculateOptimalSteps(double maxValue) {
    // Calculate optimal number of steps based on max value
    // Always use 5 steps for clean, round numbers
    if (maxValue <= 1) {
      return 4; // 0, 1 (special case for very small values)
    }
    if (maxValue <= 5) {
      return 5; // 0, 1, 2, 3, 4, 5
    }
    if (maxValue <= 10) {
      return 5; // 0, 2, 4, 6, 8, 10
    }
    if (maxValue <= 20) {
      return 4; // 0, 5, 10, 15, 20
    }
    if (maxValue <= 50) {
      return 5; // 0, 10, 20, 30, 40, 50
    }
    if (maxValue <= 100) {
      return 5; // 0, 20, 40, 60, 80, 100
    }
    return 5; // Default to 5 steps for larger values
  }

  double _roundToNiceNumber(double value) {
    // Round to nice, clean numbers for y-axis labels
    if (value <= 1) return value.round().toDouble();
    if (value <= 5) return value.round().toDouble();
    if (value <= 10) return (value / 2).round() * 2.0; // Round to even numbers
    if (value <= 20) {
      return (value / 5).round() * 5.0; // Round to multiples of 5
    }
    if (value <= 50) {
      return (value / 10).round() * 10.0; // Round to multiples of 10
    }
    if (value <= 100) {
      return (value / 20).round() * 20.0; // Round to multiples of 20
    }
    return (value / 50).round() *
        50.0; // Round to multiples of 50 for larger values
  }

  String _formatValue(double value) {
    // Always return whole numbers for y-axis labels
    if (value >= 1000000) {
      return '${(value / 1000000).round()}M';
    } else if (value >= 1000) {
      return '${(value / 1000).round()}K';
    } else {
      return value.round().toString();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
