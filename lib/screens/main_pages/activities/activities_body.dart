import 'package:acroworld/screens/main_pages/activities/calendar_component.dart';
import 'package:acroworld/screens/main_pages/activities/components/class_components/classes_view.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class ActivitiesBody extends StatelessWidget {
  const ActivitiesBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap everything by DefaultTabController length 2
    return const Column(
      children: [
        // Searchbar that sets the place as state and provider

        // date chooser that sets the state date
        // const ActivitiesQuery(),
        CalendarComponent(),
        Divider(color: CustomColors.primaryColor),

        SizedBox(height: 6),
        // flexible TabBarView that shows either the results of classes or jams
        Flexible(
          child: ClassesView(),
        )
      ],
    );
  }
}
