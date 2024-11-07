import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_event_expanded_tile.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/month_string_widget.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class EventOccurenceMonthlySortedView extends StatelessWidget {
  const EventOccurenceMonthlySortedView({
    super.key,
    required this.sortedEvents,
  });

  final List<ClassEvent> sortedEvents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sortedEvents.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          // Always show the first item
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppPaddings.small),
                child: MonthStringWidget(
                    date: DateTime.parse(sortedEvents[0].startDate!)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppPaddings.small),
                child: ClassEventExpandedTile(
                  classEvent: sortedEvents[index],
                  showFullDate: true,
                ),
              ),
            ],
          );
        }

        final previousItem = sortedEvents[index - 1];
        final currentItem = sortedEvents[index];

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
                    bottom: AppPaddings.medium, top: AppPaddings.medium),
                child: MonthStringWidget(
                    date: DateTime.parse(currentItem.startDate!)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppPaddings.small),
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
