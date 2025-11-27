import 'package:flutter/material.dart';

class MonthHeader extends StatelessWidget {
  final String monthYear;
  final bool isFirst;

  const MonthHeader({
    super.key,
    required this.monthYear,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(
        top: isFirst ? 16 : 24,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Text(
            monthYear,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 16),
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
