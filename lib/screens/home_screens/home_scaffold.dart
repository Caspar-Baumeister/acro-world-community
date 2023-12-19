import 'package:acroworld/screens/HOME_SCREENS/activities/activities.dart';
import 'package:acroworld/screens/HOME_SCREENS/components/custom_bottom_nav_bar.dart';
import 'package:acroworld/screens/HOME_SCREENS/events/event_page.dart';
import 'package:acroworld/screens/HOME_SCREENS/teachers_page/teacher_page.dart';
import 'package:acroworld/screens/home_screens/profile/profile_page.dart';
import 'package:flutter/material.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

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
    const EventsPage(),
    const TeacherPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => false,
      child: Scaffold(
        body: screens[activeIdx],
        bottomNavigationBar:
            CustomBottomNavBar(activeIdx: activeIdx, changeIdx: changeIdx),
      ),
    );
  }
}
