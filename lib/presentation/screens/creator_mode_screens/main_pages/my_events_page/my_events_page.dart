import 'package:acroworld/presentation/components/custom_tab_view.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/created_events_by_me_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/participated_events_section.dart';
import 'package:flutter/material.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      makeScrollable: false,
      child: CustomTabView(
        tabTitles: ["From you created", "You're taking part"],
        tabViews: [
          CreatedEventsByMeSection(),
          ParticipatedEventsSection(),
        ],
      ),
    );
  }
}
