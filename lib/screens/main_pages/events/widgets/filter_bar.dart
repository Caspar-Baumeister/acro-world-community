import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/main_pages/events/event_filter_page.dart';
import 'package:acroworld/screens/main_pages/events/widgets/event_filter_on_card.dart';
import 'package:acroworld/screens/main_pages/events/with_filter/filter_on_event_body.dart';
import 'package:acroworld/screens/single_event/single_event_query_wrapper.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/decorators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatelessWidget implements PreferredSizeWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      // if filter is active, show back button
      title: Row(
        children: [
          // Conditionally display the leading icon
          if (eventFilterProvider.isFilterActive())
            IconButton(
              padding:
                  const EdgeInsets.only(left: 0), // Adjust this value as needed

              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => eventFilterProvider.resetFilter(),
            ),
          Expanded(
            child: InkWell(
              onTap: () =>
                  showSearch(context: context, delegate: EventSearchDelegate()),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                decoration: searchBarDecoration,
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black),
                    const SizedBox(width: 10),
                    Text(
                      'Search...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              padding: const EdgeInsets.only(right: 12),
              icon: Icon(Icons.filter_list,
                  color: eventFilterProvider.isFilterActive()
                      ? Colors.black
                      : const Color.fromARGB(255, 54, 54, 54).withOpacity(0.5)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventFilterPage(),
                  ),
                );
              },
            ),
            if (eventFilterProvider.isFilterActive())
              Positioned(
                bottom: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventFilterPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: CustomColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    child: Center(
                      child: Text(
                        eventFilterProvider.getActiveFilterCount().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
    // if only one suggestion, click on that one suggestion otherwise do nothing
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    List<EventModel> eventSuggestions = List<EventModel>.from(
        eventFilterProvider.activeEvents.where((EventModel event) =>
            event.name != null &&
            event.name!.toLowerCase().contains(query.toLowerCase())));

    if (eventSuggestions.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SingleEventQueryWrapper(
              eventId: eventSuggestions[0].id!,
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
                child: EventFilterOnCard(
                  event: eventSuggestions[index],
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
            child: EventFilterOnCard(
              event: currentItem,
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
                child: EventFilterOnCard(
                  event: currentItem,
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
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);

    List<EventModel> eventSuggestions = List<EventModel>.from(
        eventFilterProvider.activeEvents.where((EventModel event) =>
            event.name != null &&
            event.name!.toLowerCase().contains(query.toLowerCase())));
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
                child: EventFilterOnCard(
                  event: eventSuggestions[index],
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
            child: EventFilterOnCard(
              event: currentItem,
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
                child: EventFilterOnCard(
                  event: currentItem,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
