import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/sections/responsive_event_list.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/routing/routes/page_routes/single_event_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onPressed: () {
          if (query == '') {
            close(context, null);
          }
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  String get searchFieldLabel => 'Search events...';

  @override
  TextStyle? get searchFieldStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final discoveryState =
        ProviderScope.containerOf(context).read(discoveryProvider);
    List<ClassEvent> eventSuggestions = List<ClassEvent>.from(
        discoveryState.filteredEventOccurences.where((ClassEvent event) =>
            event.classModel?.name != null &&
            event.classModel!.name!
                .toLowerCase()
                .contains(query.toLowerCase())));

    eventSuggestions.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    if (eventSuggestions.length == 1) {
      // if you press enter and there is only one suggestion, navigate to it
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(context).push(
          SingleEventPageRoute(
              classModel: eventSuggestions[0].classModel!,
              classEvent: eventSuggestions[0]),
        );
      });
      query = "";
    }

    // Convert to EventCardData and display in grid
    final eventCardData = eventSuggestions
        .map((event) => EventCardData.fromClassEvent(event))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ResponsiveEventList(
        events: eventCardData,
        isGridMode: true,
        isLoading: false,
        onEventTap: () {
          // Handle event tap - could navigate to event details
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final discoveryState =
        ProviderScope.containerOf(context).read(discoveryProvider);

    List<ClassEvent> eventSuggestions = List<ClassEvent>.from(
        discoveryState.filteredEventOccurences.where((ClassEvent event) =>
            event.classModel?.name != null &&
            event.classModel!.name!
                .toLowerCase()
                .contains(query.toLowerCase())));

    eventSuggestions.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    // Convert to EventCardData and display in grid
    final eventCardData = eventSuggestions
        .map((event) => EventCardData.fromClassEvent(event))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ResponsiveEventList(
        events: eventCardData,
        isGridMode: true,
        isLoading: false,
        onEventTap: () {
          // Handle event tap - could navigate to event details
        },
      ),
    );
  }
}
