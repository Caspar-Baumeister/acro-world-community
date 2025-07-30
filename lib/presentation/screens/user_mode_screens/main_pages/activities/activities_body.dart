import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/calendar_component.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/classes/classes_view.dart';
import 'package:flutter/material.dart';

class ActivitiesBody extends StatelessWidget {
  const ActivitiesBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap everything by DefaultTabController length 2
    return Column(
      children: [
        // Searchbar that sets the place as state and provider

        // date chooser that sets the state date
        // const ActivitiesQuery(),
        const CalendarComponent(),
        Divider(color: Theme.of(context).colorScheme.primary),

        const SizedBox(height: 6),
        // flexible TabBarView that shows either the results of classes or jams
        const Flexible(
          child: ClassesView(),
        )
      ],
    );
  }
}
