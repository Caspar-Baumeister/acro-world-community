import 'package:acroworld/screens/HOME_SCREENS/events/event_page.dart';
import 'package:acroworld/screens/HOME_SCREENS/activities/activities.dart';
import 'package:acroworld/screens/HOME_SCREENS/components/custom_bottom_nav_bar.dart';
import 'package:acroworld/screens/HOME_SCREENS/teachers_page/teacher_page.dart';
import 'package:acroworld/screens/HOME_SCREENS/user_communities/user_communities.dart';
import 'package:flutter/material.dart';

class HomeScaffold extends StatefulWidget {
  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int activeIdx = 0;

  changeIdx(int idx) {
    setState(() {
      activeIdx = idx;
    });
  }

  List<Widget> screens = [
    const ActivitiesPage(),
    const TeacherPage(),
    const EventsPage(),
    const UserCommunities()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: screens[activeIdx],
        bottomNavigationBar:
            CustomBottomNavBar(activeIdx: activeIdx, changeIdx: changeIdx),
      ),
    );
  }
}
