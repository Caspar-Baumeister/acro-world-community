import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/provider/event_filter_provider.dart';
import 'package:acroworld/screens/home_screens/events/widgets/event_filter_on_card.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// This page body has only one downwards scroll with full with cards
class FilterOnEventBody extends StatelessWidget {
  const FilterOnEventBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventFilterProvider eventFilterProvider =
        Provider.of<EventFilterProvider>(context);

    List<EventModel> activeEvents = eventFilterProvider.activeEvents;
    activeEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    return activeEvents.isEmpty
        ? SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "We could not find any events for your search",
                  style: H14W4,
                ),
                const SizedBox(
                  height: 10,
                ),
                StandardButton(
                  text: "Reset Filter",
                  onPressed: () {
                    eventFilterProvider.resetFilter();
                  },
                  width: STANDART_BUTTON_WIDTH,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: activeEvents.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                // Always show the first item
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: MonthStringWidget(
                          date: DateTime.parse(activeEvents[0].startDate!)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: EventFilterOnCard(
                        event: activeEvents[index],
                      ),
                    ),
                  ],
                );
              }

              final previousItem = activeEvents[index - 1];
              final currentItem = activeEvents[index];

              if (DateTime.parse(previousItem.startDate!).month ==
                  DateTime.parse(currentItem.startDate!).month) {
                // Same date, just display the item
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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

class MonthStringWidget extends StatelessWidget {
  const MonthStringWidget({Key? key, required this.date}) : super(key: key);
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              height: 2,
              thickness: 2,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(DateFormat.yMMMM().format(date)),
          ),
          const Expanded(
            child: Divider(
              height: 2,
              thickness: 2,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
