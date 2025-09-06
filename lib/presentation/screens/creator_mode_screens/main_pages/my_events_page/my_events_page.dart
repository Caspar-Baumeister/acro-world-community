import 'package:acroworld/presentation/components/buttons/floating_action_button.dart';
import 'package:acroworld/presentation/components/custom_tab_view.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/created_events_by_me_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/participated_events_section.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      children: [
        const BasePage(
          makeScrollable: false,
          child: CustomTabView(
            tabTitles: ["From you created", "You're taking part"],
            tabViews: [
              CreatedEventsByMeSection(),
              ParticipatedEventsSection(),
            ],
          ),
        ),
        // Floating Create Event Button
        FloatingActionButton(
          title: "Create Event",
          subtitle: "Add a new class or workshop",
          onPressed: () => context.pushNamed(createEditEventRoute),
          backgroundColor: colorScheme.primary,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
