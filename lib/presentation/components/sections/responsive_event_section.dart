import 'package:acroworld/presentation/components/sections/responsive_event_list.dart';
import 'package:flutter/material.dart';

/// Pure UI component for event sections with header and responsive layout
class ResponsiveEventSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<EventCardData> events;
  final bool isGridMode;
  final VoidCallback? onViewAll;
  final VoidCallback? onEventTap;
  final bool isLoading;

  const ResponsiveEventSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.events,
    this.isGridMode = false,
    this.onViewAll,
    this.onEventTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // View all button
                if (onViewAll != null && !isGridMode)
                  TextButton(
                    onPressed: onViewAll,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      "view all",
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Event list
          ResponsiveEventList(
            events: events,
            isGridMode: isGridMode,
            onEventTap: onEventTap,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
