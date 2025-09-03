import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/sections/responsive_event_list.dart';
import 'package:acroworld/provider/riverpod_provider/discovery_provider.dart';
import 'package:acroworld/routing/routes/page_routes/single_event_page_route.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
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
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final discoveryState = ProviderScope.containerOf(context).read(discoveryProvider);
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
        onEventTap: () {
          // Handle event tap - could navigate to event details
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final discoveryState = ProviderScope.containerOf(context).read(discoveryProvider);

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
        onEventTap: () {
          // Handle event tap - could navigate to event details
        },
      ),
    );
  }
}
