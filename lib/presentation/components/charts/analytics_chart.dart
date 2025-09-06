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
          // Chart
          SizedBox(
            height: 120,
            child: _buildChart(context, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, ColorScheme colorScheme) {
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

    final maxValue = dataPoints.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue = dataPoints.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    return CustomPaint(
      painter: _ChartPainter(
        dataPoints: dataPoints,
        maxValue: maxValue,
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

class _ChartPainter extends CustomPainter {
  final List<ChartDataPoint> dataPoints;
  final double maxValue;
  final double minValue;
  final double range;
  final Color primaryColor;
  final ColorScheme colorScheme;

  _ChartPainter({
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

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (dataPoints.length - 1);
    
    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final x = i * stepX;
      final normalizedValue = range > 0 ? (point.value - minValue) / range : 0.5;
      final y = size.height - (normalizedValue * size.height * 0.8) - (size.height * 0.1);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Close the fill path
    fillPath.lineTo(size.width, size.height);
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
      final x = i * stepX;
      final normalizedValue = range > 0 ? (point.value - minValue) / range : 0.5;
      final y = size.height - (normalizedValue * size.height * 0.8) - (size.height * 0.1);

      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
