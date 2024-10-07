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
    CalendarProvider calendarProvider = Provider.of<CalendarProvider>(context);
    if (calendarProvider.loading) {
      return const LoadingWidget();
    }

    if (calendarProvider.weekClassEvents.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                const Text("There are no activities close to you."),
                const SizedBox(height: AppPaddings.large),
                StandardButton(
                    text: "increase search radius",
                    onPressed: () => calendarProvider.increaseRadius()),
              ],
            ),
          )
        ],
      );
    }

    List<ClassEvent> classEvents = calendarProvider.focusedDayClassEvents;

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

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: classEvents.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4, bottom: AppPaddings.small),
            child: ClassEventExpandedTile(
              classEvent: classEvents[index],
            ),
          );
        },
      ),
    );
  }
}
