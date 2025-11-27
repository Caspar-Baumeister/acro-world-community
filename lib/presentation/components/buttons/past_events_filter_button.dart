import 'package:acroworld/presentation/components/input/modern_search_bar.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          ModernFilterChip(
            label: showPastEvents ? 'Hide Past Events' : 'Show Past Events',
            isSelected: showPastEvents,
            onSelected: onToggle,
            icon: showPastEvents ? Icons.visibility_off : Icons.visibility,
          ),
        ],
      ),
    );
  }
}
