import 'package:acroworld/models/event/event_instance.dart';
import 'package:acroworld/screens/home_screens/event_calendar/event_tile.dart';
import 'package:flutter/material.dart';

class EventListView extends StatelessWidget {
  const EventListView({
    Key? key,
    required this.focusDayEvents,
  }) : super(key: key);

  final List<EventInstance> focusDayEvents;

  @override
  Widget build(BuildContext context) {
    // ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    // List<ClassEvent> classEvents = activityProvider.activeClasseEvents;
    try {
      focusDayEvents.sort((a, b) =>
          DateTime.parse(b.startDate!).isBefore(DateTime.parse(a.startDate!))
              ? 1
              : 0);
    } catch (e) {
      print(e.toString());
    }
    return focusDayEvents.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text("no events found"),
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: focusDayEvents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  child: EventTile(
                    event: focusDayEvents[index],
                  ),
                );
              },
            ),
          );
  }
}
