import 'package:flutter/material.dart';

class PastEventsFilterButton extends StatelessWidget {
  final bool showPastEvents;
  final VoidCallback onToggle;

  const PastEventsFilterButton({
    super.key,
    required this.showPastEvents,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            child: TextButton.icon(
              onPressed: onToggle,
              icon: Icon(
                showPastEvents ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: colorScheme.primary,
              ),
              label: Text(
                showPastEvents ? 'Hide Past Events' : 'Show Past Events',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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
