import 'package:acroworld/presentation/components/sections/responsive_event_list.dart';
import 'package:acroworld/presentation/components/sections/responsive_event_section.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverDashboardBody extends ConsumerStatefulWidget {
  const DiscoverDashboardBody({super.key});

  @override
  ConsumerState<DiscoverDashboardBody> createState() =>
      _DiscoverDashboardBodyState();
}

class _DiscoverDashboardBodyState extends ConsumerState<DiscoverDashboardBody> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final discoveryState = ref.watch(discoveryProvider);

    // Build event sections for each event type
    List<Widget> eventSections = discoveryState.allEventTypes
        .map((EventType eventType) => ResponsiveEventSection(
              title: eventType.name,
              events: discoveryState
                  .getEventsByType(eventType)
                  .map((event) => EventCardData.fromClassEvent(event))
                  .toList(),
              isLoading: discoveryState.loading,
              onViewAll: () {
                ref
                    .read(discoveryProvider.notifier)
                    .changeActiveCategory(eventType);
              },
            ))
        .toList();

    return RefreshIndicator(
      onRefresh: () async =>
          await ref.read(discoveryProvider.notifier).fetchAllEventOccurences(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show highlighted events if available
            if (discoveryState.getHighlightedEvents().isNotEmpty ||
                discoveryState.loading)
              ResponsiveEventSection(
                title: 'Highlights',
                events: discoveryState
                    .getHighlightedEvents()
                    .map((event) => EventCardData.fromClassEvent(event))
                    .toList(),
                isLoading: discoveryState.loading,
                onViewAll: () {
                  ref
                      .read(discoveryProvider.notifier)
                      .setToOnlyHighlightedFilter();
                },
              ),
            // Show bookable events if available
            if (discoveryState.getBookableEvents().isNotEmpty ||
                discoveryState.loading)
              ResponsiveEventSection(
                title: 'Bookable Events',
                subtitle: "Tickets available here!",
                events: discoveryState
                    .getBookableEvents()
                    .map((event) => EventCardData.fromClassEvent(event))
                    .toList(),
                isLoading: discoveryState.loading,
                onViewAll: () {
                  ref
                      .read(discoveryProvider.notifier)
                      .setToOnlyBookableFilter();
                },
              ),
            // Show all event type sections
            ...eventSections,
            // Show message if no events at all
            if (discoveryState.allEventOccurences.isEmpty &&
                !discoveryState.loading)
              _buildEmptyState(theme, colorScheme),
            // Bottom padding for floating button
            const SizedBox(height: AppDimensions.bottomNavHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingExtraLarge),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: AppDimensions.iconSizeExtraLarge,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Text(
              'No events found',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(
              'Try refreshing or check your connection',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
