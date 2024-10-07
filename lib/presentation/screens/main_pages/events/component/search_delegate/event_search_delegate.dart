import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/main_pages/activities/components/class_components/class_event_expanded_tile.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/presentation/shared_components/month_string_widget.dart';
import 'package:acroworld/state/provider/discover_provider.dart';
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

    if (eventSuggestions.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SingleClassPage(
              classEvent: eventSuggestions[0],
              clas: eventSuggestions[0].classModel!,
            ),
          ),
        );
      });
      query = "";
    }
    return ListView.builder(
      itemCount: eventSuggestions.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          // Always show the first item
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: MonthStringWidget(
                    date: DateTime.parse(eventSuggestions[0].startDate!)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ClassEventExpandedTile(
                  classEvent: eventSuggestions[index],
                  showFullDate: true,
                ),
              ),
            ],
          );
        }

        final previousItem = eventSuggestions[index - 1];
        final currentItem = eventSuggestions[index];

        if (DateTime.parse(previousItem.startDate!).month ==
            DateTime.parse(currentItem.startDate!).month) {
          // Same date, just display the item
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ClassEventExpandedTile(
              classEvent: currentItem,
              showFullDate: true,
            ),
          );
        } else {
          // Different date, display a date separator and the item
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 15),
                child: MonthStringWidget(
                    date: DateTime.parse(currentItem.startDate!)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ClassEventExpandedTile(
                  classEvent: currentItem,
                  showFullDate: true,
                ),
              ),
            ],
          );
        }
      },
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

    return ListView.builder(
      itemCount: eventSuggestions.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          // Always show the first item
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: MonthStringWidget(
                    date: DateTime.parse(eventSuggestions[0].startDate!)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ClassEventExpandedTile(
                  classEvent: eventSuggestions[index],
                  showFullDate: true,
                ),
              ),
            ],
          );
        }

        final previousItem = eventSuggestions[index - 1];
        final currentItem = eventSuggestions[index];

        if (DateTime.parse(previousItem.startDate!).month ==
            DateTime.parse(currentItem.startDate!).month) {
          // Same date, just display the item
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ClassEventExpandedTile(
              classEvent: currentItem,
              showFullDate: true,
            ),
          );
        } else {
          // Different date, display a date separator and the item
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 15),
                child: MonthStringWidget(
                    date: DateTime.parse(currentItem.startDate!)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ClassEventExpandedTile(
                  classEvent: currentItem,
                  showFullDate: true,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
