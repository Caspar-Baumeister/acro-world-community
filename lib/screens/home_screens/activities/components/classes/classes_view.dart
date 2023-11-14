import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/activity_provider.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/class_event_expanded_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassesView extends StatelessWidget {
  const ClassesView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    List<ClassEvent> classEvents = activityProvider.activeClasseEvents;
    try {
      classEvents.sort((a, b) =>
          DateTime.parse(b.startDate!).isBefore(DateTime.parse(a.startDate!))
              ? 1
              : 0);
    } catch (e) {
      print(e.toString());
    }
    return classEvents.isEmpty
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("no classes found"),
              )
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: classEvents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, right: 4, bottom: 20),
                  child: ClassEventExpandedTile(
                    classEvent: classEvents[index],
                  ),
                );
              },
            ),
          );
  }
}
