import 'package:acroworld/components/buttons/place_button/place_button.dart';
import 'package:acroworld/screens/home_screens/activities/calendar_component.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/classes_view.dart';
import 'package:acroworld/screens/map/map_page.dart';
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
        CalendarAppBar(),

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

class CalendarAppBar extends StatelessWidget {
  const CalendarAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: PlaceButton(
            rightPadding: false,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FlutterMapScreen()),
          ),
          icon: const Icon(Icons.location_on_outlined),
        ),
      ],
    );
  }
}
