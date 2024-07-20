import 'package:acroworld/components/bottom_navbar/primary_bottom_navbar.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/screens/main_pages/activities/activities_body.dart';
import 'package:acroworld/screens/main_pages/activities/calendar_app_bar.dart';
import 'package:flutter/material.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      makeScrollable: false,
      appBar: CalendarAppBar(),
      bottomNavigationBar: PrimaryBottomNavbar(selectedIndex: 1),
      child: ActivitiesBody(),
    );
  }
}
