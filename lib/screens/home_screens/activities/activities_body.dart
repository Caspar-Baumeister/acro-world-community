import 'package:acroworld/components/place_button/place_button.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/home_screens/activities/activities_query.dart';
import 'package:acroworld/screens/home_screens/activities/components/classes/classes_view.dart';
import 'package:acroworld/screens/home_screens/activities/components/jams/jam_view.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ActivitiesBody extends StatefulWidget {
  const ActivitiesBody({Key? key}) : super(key: key);

  @override
  State<ActivitiesBody> createState() => _ActivitiesBodyState();
}

class _ActivitiesBodyState extends State<ActivitiesBody> {
  String activityType = "classes";

  @override
  Widget build(BuildContext context) {
    // Wrap everything by DefaultTabController length 2
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        children: [
          // Searchbar that sets the place as state and provider
          const SizedBox(height: 10),
          const SizedBox(
            child: PlaceButton(),
          ),

          // date chooser that sets the state date
          ActivitiesQuery(activityType: activityType),
          const Divider(color: PRIMARY_COLOR),
          TabBar(
            padding: const EdgeInsets.only(bottom: 6, top: 4),
            onTap: (int value) => setState(() {
              activityType = value == 1 ? "jams" : "classes";
            }),
            tabs: const [
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Classes",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Jams",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          // flexible TabBarView that shows either the results of classes or jams
          const Flexible(
            child: TabBarView(
              children: [
                ClassesView(),
                JamsView(),
              ],
            ),
          )
        ],
      )),
    );
  }
}
