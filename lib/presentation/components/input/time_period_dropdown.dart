import 'package:flutter/material.dart';

class TimePeriodDropdown extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const TimePeriodDropdown({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  static const List<TimePeriodOption> _periods = [
    TimePeriodOption(value: 'today', label: 'Today'),
    TimePeriodOption(value: 'yesterday', label: 'Yesterday'),
    TimePeriodOption(value: 'last_7_days', label: 'Last 7 days'),
    TimePeriodOption(value: 'last_30_days', label: 'Last 30 days'),
    TimePeriodOption(value: 'this_month', label: 'This month'),
    TimePeriodOption(value: 'this_year', label: 'This year'),
    TimePeriodOption(value: 'all_time', label: 'All time'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPeriod,
          onChanged: (String? newValue) {
            if (newValue != null) {
              onPeriodChanged(newValue);
            }
          },
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.onSurfaceVariant,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          items: _periods.map((TimePeriodOption period) {
            return DropdownMenuItem<String>(
              value: period.value,
              child: Row(
                children: [
                  Icon(
                    _getIconForPeriod(period.value),
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Text(period.label),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getIconForPeriod(String period) {
    switch (period) {
      case 'today':
        return Icons.today;
      case 'yesterday':
        return Icons.history;
      case 'last_7_days':
        return Icons.date_range;
      case 'last_30_days':
        return Icons.calendar_month;
      case 'this_month':
        return Icons.calendar_today;
      case 'this_year':
        return Icons.calendar_today;
      case 'all_time':
        return Icons.all_inclusive;
      default:
        return Icons.schedule;
    }
  }
}

class TimePeriodOption {
  final String value;
  final String label;

  const TimePeriodOption({
    required this.value,
    required this.label,
  });
}
