import 'package:acroworld/screens/HOME_SCREENS/activities/activities_body.dart';
import 'package:flutter/material.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: ActivitiesBody(),
      ),
    );
  }
}
