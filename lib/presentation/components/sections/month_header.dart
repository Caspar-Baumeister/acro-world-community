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
        top: isFirst ? 16 : 32,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              monthYear,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
