import 'package:acroworld/components/buttons/place_button/place_button.dart';
import 'package:acroworld/models/event/event_instance.dart';
import 'package:acroworld/screens/home_screens/activities/components/create_class_modal.dart';
import 'package:acroworld/screens/home_screens/event_calendar/event_list_view.dart';
import 'package:acroworld/screens/home_screens/event_calendar/event_calendar_query.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class EventCalendarBody extends StatefulWidget {
  const EventCalendarBody({Key? key}) : super(key: key);

  @override
  State<EventCalendarBody> createState() => _EventCalendarBodyState();
}

class _EventCalendarBodyState extends State<EventCalendarBody> {
  // keeps track of the List of events that are be shown at the choosen day

  List<EventInstance> focusDayEvents = [];

  setFocusDayEvents(newFocusDayEvents) {
    setState(() {
      focusDayEvents = newFocusDayEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Searchbar that sets the place provider
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: SizedBox(
                height: 40,
                child: PlaceButton(
                  rightPadding: false,
                ),
              ),
            ),
            IconButton(
              onPressed: () => buildMortal(context, const CreateClassModal()),
              icon: const Icon(Icons.add),
            ),
          ],
        ),

        // date chooser that sets the state date
        EventCalendarQuery(setFocusDayEvents: setFocusDayEvents),
        const Divider(color: PRIMARY_COLOR),
        // flexible TabBarView that shows either the results of classes or jams
        Flexible(
          child: EventListView(focusDayEvents: focusDayEvents),
        )
      ],
    );
  }
}
