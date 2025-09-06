import 'package:acroworld/presentation/components/buttons/floating_action_button.dart';
import 'package:acroworld/presentation/components/custom_tab_view.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/modals/create_new_event_from_existing_modal.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/created_events_by_me_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/sections/participated_events_section.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

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
        CustomFloatingActionButton(
          title: "Create Event",
          subtitle: "Add a new class or workshop",
          onPressed: () => buildMortal(
            context,
            const CreateNewEventFromExistingModal(),
          ),
          backgroundColor: colorScheme.primary,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
