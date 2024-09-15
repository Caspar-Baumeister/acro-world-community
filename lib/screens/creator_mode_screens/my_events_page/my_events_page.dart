import 'package:acroworld/components/bottom_navbar/creator_mode/creator_mode_primary_bottom_navbar.dart';
import 'package:acroworld/components/custom_tab_view.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/screens/creator_mode_screens/my_events_page/sections/created_events_by_me_section.dart';
import 'package:acroworld/screens/creator_mode_screens/my_events_page/sections/participated_events_section.dart';
import 'package:flutter/material.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      makeScrollable: false,
      bottomNavigationBar: CreatorModePrimaryBottomNavbar(selectedIndex: 1),
      child: CustomTabView(
        tabTitles: ["From you created", "Your taking part"],
        tabViews: [
          CreatedEventsByMeSection(),
          ParticipatedEventsSection(),
        ],
      ),
    );
  }
}
