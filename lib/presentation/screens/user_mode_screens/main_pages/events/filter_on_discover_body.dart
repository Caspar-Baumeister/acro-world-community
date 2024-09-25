import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_event_expanded_tile.dart';
import 'package:acroworld/provider/discover_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// This page body has only one downwards scroll with full with cards
class FilterOnDiscoveryBody extends StatelessWidget {
  const FilterOnDiscoveryBody({super.key});

  @override
  Widget build(BuildContext context) {
    DiscoveryProvider discoveryProvider =
        Provider.of<DiscoveryProvider>(context);

    List<ClassEvent> activeEvents = discoveryProvider.filteredEventOccurences;
    activeEvents.sort((a, b) => a.startDate!.compareTo(b.startDate!));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
      child: activeEvents.isEmpty
          ? SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "We could not find any events for your search",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StandardButton(
                    text: "Reset Filter",
                    onPressed: () {
                      discoveryProvider.resetFilter();
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
                        padding:
                            const EdgeInsets.only(bottom: AppPaddings.small),
                        child: MonthStringWidget(
                            date: DateTime.parse(activeEvents[0].startDate!)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppPaddings.small),
                        child: ClassEventExpandedTile(
                          classEvent: activeEvents[index],
                          showFullDate: true,
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
                    padding: const EdgeInsets.only(bottom: AppPaddings.small),
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
                        padding: const EdgeInsets.only(
                            bottom: AppPaddings.medium,
                            top: AppPaddings.medium),
                        child: MonthStringWidget(
                            date: DateTime.parse(currentItem.startDate!)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppPaddings.small),
                        child: ClassEventExpandedTile(
                          classEvent: currentItem,
                          showFullDate: true,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}

class MonthStringWidget extends StatelessWidget {
  const MonthStringWidget({super.key, required this.date});
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
