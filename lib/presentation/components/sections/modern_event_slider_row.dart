import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/cards/modern_event_discovery_card.dart';
import 'package:acroworld/presentation/components/loading/shimmer_skeleton.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

/// Modern event slider row with skeleton loading and theme-based styling
class ModernEventSliderRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<ClassEvent> events;
  final VoidCallback? onViewAll;
  final bool isLoading;
  final int skeletonCardCount;

  const ModernEventSliderRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.events,
    this.onViewAll,
    this.isLoading = false,
    this.skeletonCardCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        _buildHeader(context, theme, colorScheme),
        const SizedBox(height: AppDimensions.spacingSmall),
        // Content section
        _buildContent(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: GestureDetector(
        onTap: onViewAll,
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
                    const SizedBox(height: AppDimensions.spacingExtraSmall),
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
            if (onViewAll != null)
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
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildSkeletonContent();
    }

    if (events.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildEventCards();
  }

  Widget _buildSkeletonContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          skeletonCardCount,
          (index) => Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? AppDimensions.spacingMedium : AppDimensions.spacingSmall,
              right: index == skeletonCardCount - 1 ? AppDimensions.spacingMedium : 0,
            ),
            child: const EventDiscoveryCardSkeleton(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              "No events available",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Check back later for new events",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: events.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? AppDimensions.spacingMedium : AppDimensions.spacingSmall,
              right: index == events.length - 1 ? AppDimensions.spacingMedium : 0,
            ),
            child: ModernEventDiscoveryCard(classEvent: event),
          );
        }).toList(),
      ),
    );
  }
}
