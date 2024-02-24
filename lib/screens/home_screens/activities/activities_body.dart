import 'package:acroworld/components/buttons/place_button/place_button.dart';
import 'package:acroworld/screens/home_screens/activities/activities_query.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/classes_view.dart';
import 'package:acroworld/screens/map/map_page.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class ActivitiesBody extends StatefulWidget {
  const ActivitiesBody({super.key});

  @override
  State<ActivitiesBody> createState() => _ActivitiesBodyState();
}

class _ActivitiesBodyState extends State<ActivitiesBody> {
  String activityType = "classes";

  @override
  Widget build(BuildContext context) {
    // Wrap everything by DefaultTabController length 2
    return Column(
      children: [
        // Searchbar that sets the place as state and provider
        Row(
          children: [
            const Expanded(
              child: PlaceButton(
                rightPadding: false,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const FlutterMapScreen()),
              ),
              icon: const Icon(Icons.location_on_outlined),
            ),
          ],
        ),

        // date chooser that sets the state date
        const ActivitiesQuery(),
        const Divider(color: CustomColors.primaryColor),

        const SizedBox(height: 6),
        // flexible TabBarView that shows either the results of classes or jams
        const Flexible(
          child: ClassesView(),
        )
      ],
    );
  }
}
