import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/event_occurence_monthly_sorted_view.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/routing/routes/page_routes/single_event_page_route.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);
    List<ClassEvent> eventSuggestions = List<ClassEvent>.from(
        discoveryProvider.filteredEventOccurences.where((ClassEvent event) =>
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
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.spacingMedium),
      child: EventOccurenceMonthlySortedView(sortedEvents: eventSuggestions),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);

    List<ClassEvent> eventSuggestions = List<ClassEvent>.from(
        discoveryProvider.filteredEventOccurences.where((ClassEvent event) =>
            event.classModel?.name != null &&
            event.classModel!.name!
                .toLowerCase()
                .contains(query.toLowerCase())));

    eventSuggestions.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.spacingMedium),
      child: EventOccurenceMonthlySortedView(sortedEvents: eventSuggestions),
    );
  }
}
