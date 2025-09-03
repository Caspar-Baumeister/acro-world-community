import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/components/sections/responsive_event_list.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/events/components/month_string_widget.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class EventOccurenceMonthlyGridView extends StatelessWidget {
  const EventOccurenceMonthlyGridView({
    super.key,
    required this.sortedEvents,
  });

  final List<ClassEvent> sortedEvents;

  @override
  Widget build(BuildContext context) {
    if (sortedEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group events by month
    final Map<String, List<ClassEvent>> eventsByMonth = {};
    
    for (final event in sortedEvents) {
      final date = DateTime.parse(event.startDate!);
      final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      
      if (!eventsByMonth.containsKey(monthKey)) {
        eventsByMonth[monthKey] = [];
      }
      eventsByMonth[monthKey]!.add(event);
    }

    // Sort months chronologically
    final sortedMonths = eventsByMonth.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return ListView.builder(
      itemCount: sortedMonths.length,
      itemBuilder: (BuildContext context, int monthIndex) {
        final monthKey = sortedMonths[monthIndex];
        final monthEvents = eventsByMonth[monthKey]!;
        final firstEvent = monthEvents.first;
        final date = DateTime.parse(firstEvent.startDate!);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month divider
            Padding(
              padding: EdgeInsets.only(
                bottom: AppDimensions.spacingMedium,
                top: monthIndex > 0 ? AppDimensions.spacingMedium : 0,
              ),
              child: MonthStringWidget(date: date),
            ),
            // Grid view for this month's events
            ResponsiveEventList(
              events: monthEvents.map((event) => EventCardData.fromClassEvent(event)).toList(),
              isGridMode: true,
              isLoading: false,
            ),
            // Add some spacing at the bottom
            if (monthIndex < sortedMonths.length - 1)
              const SizedBox(height: AppDimensions.spacingMedium),
          ],
        );
      },
    );
  }
}
