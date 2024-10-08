import 'package:acroworld/core/utils/constants.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/main_pages/activities/components/class_components/class_event_expanded_tile.dart';
import 'package:acroworld/presentation/shared_components/buttons/standart_button.dart';
import 'package:acroworld/presentation/shared_components/loading_widget.dart';
import 'package:acroworld/state/provider/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesView extends StatelessWidget {
  const ClassesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Listens to the CalendarProvider to get the class events
    CalendarProvider calendarProvider = Provider.of<CalendarProvider>(context);

    // show loading widget when calendarProvider is loading data
    if (calendarProvider.loading) {
      return const LoadingWidget();
    }

    // show message when there are no activities close to the user
    if (calendarProvider.weekClassEvents.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("There are no activities close to you."),
          const SizedBox(height: AppPaddings.large),
          StandardButton(
              text: "increase search radius",
              onPressed: () => calendarProvider.increaseRadius()),
        ],
      );
    }

    List<ClassEvent> classEvents = calendarProvider.focusedDayClassEvents;

    // show message when there are no activities on the selected day but there are activities close to the user
    if (classEvents.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("There are no activities on this day."),
          )
        ],
      );
    }

    // show the list of activities on the selected day
    return Padding(
      padding: const EdgeInsets.only(top: AppPaddings.small),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: classEvents.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: AppPaddings.small,
                right: AppPaddings.small,
                bottom: AppPaddings.small),
            child: ClassEventExpandedTile(
              classEvent: classEvents[index],
            ),
          );
        },
      ),
    );
  }
}
