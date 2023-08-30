import 'package:acroworld/components/buttons/standard_icon_button.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/event_filter_page.dart';
import 'package:acroworld/screens/home_screens/events/widgets/create_event_modal.dart';
import 'package:acroworld/screens/home_screens/events/widgets/event_filter_on_card.dart';
import 'package:acroworld/screens/home_screens/events/with_filter/filter_on_event_body.dart';
import 'package:acroworld/screens/single_event/single_event_page.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatelessWidget with PreferredSizeWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          eventFilterProvider.isFilterActive()
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                      onTap: () => eventFilterProvider.resetFilter(),
                      child: const Icon(Icons.arrow_back_ios_new_rounded)),
                )
              : Container(),
          Flexible(
            child: StandardIconButton(
              text: eventFilterProvider.filterString(),
              icon: Icons.filter_list,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventFilterPage(),
                  ),
                );
              },
              showClose: eventFilterProvider.isFilterActive(),
              onClose: () => eventFilterProvider.resetFilter(),
            ),
          ),
          IconButton(
            onPressed: () => buildMortal(context, const CreateEventModal()),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: EventSearchDelegate()),
            icon: const Icon(Icons.search),
          )
          // GestureDetector(
          //   onTap: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const SearchPageEvents(),
          //     ),
          //   ),

          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 8.0),
          //     child: Icon(Icons.search),
          //   ),
          // )
        ],
      ),
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
            builder: (context) => SingleEventPage(
              event: eventSuggestions[0],
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
