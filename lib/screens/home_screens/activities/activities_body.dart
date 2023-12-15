import 'package:acroworld/components/buttons/place_button/place_button.dart';
import 'package:acroworld/screens/home_screens/activities/activities_query.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/classes_view.dart';
import 'package:acroworld/screens/home_screens/activities/components/create_class_modal.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class ActivitiesBody extends StatefulWidget {
  ActivitiesBody({Key? key}) : super(key: key);

  @override
  State<ActivitiesBody> createState() => _ActivitiesBodyState();
}

class _ActivitiesBodyState extends State<ActivitiesBody> {
  String activityType = "classes";
  final Widget activitesQuery = const ActivitiesQuery();

  @override
  Widget build(BuildContext context) {
    print('activitesQuery ${activitesQuery.hashCode}');
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
              onPressed: () => buildMortal(context, const CreateClassModal()),
              icon: const Icon(Icons.add),
            ),
          ],
        ),

        // date chooser that sets the state date
        activitesQuery,
        const Divider(color: PRIMARY_COLOR),

        const SizedBox(height: 6),
        // flexible TabBarView that shows either the results of classes or jams
        const Flexible(
          child: ClassesView(),
        )
      ],
    );
  }
}
