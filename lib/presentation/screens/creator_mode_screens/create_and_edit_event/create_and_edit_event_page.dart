import 'package:acroworld/presentation/components/progress/compact_progress_bar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/community_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/description_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/general_event_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/market_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/occurrences_step.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateAndEditEventPage extends ConsumerStatefulWidget {
  const CreateAndEditEventPage({super.key, required this.isEditing});

  // can either edit the existing event or use it as a template to create a new event
  final bool isEditing;

  @override
  ConsumerState<CreateAndEditEventPage> createState() =>
      _CreateAndEditEventPageState();
}

class _CreateAndEditEventPageState
    extends ConsumerState<CreateAndEditEventPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventCreationAndEditingProvider);

    final userAsync = ref.watch(userRiverpodProvider);

    final List<Widget> pages = [
      // Step 1: General Event Details
      GeneralEventStep(
        onFinished: () {
          ref.read(eventCreationAndEditingProvider.notifier).setPage(1);
          setState(() {});
        },
      ),
      // Step 2: Description
      DescriptionStep(
        onFinished: () {
          ref.read(eventCreationAndEditingProvider.notifier).setPage(2);
          setState(() {});
        },
      ),
      // Step 3: Occurrences
      OccurrenceStep(
        onFinished: () {
          ref.read(eventCreationAndEditingProvider.notifier).setPage(3);
          setState(() {});
        },
      ),
      // Step 4: Community
      CommunityStep(
        onFinished: () {
          ref.read(eventCreationAndEditingProvider.notifier).setPage(4);
          setState(() {});
        },
      ),
      // Step 5: Market
      MarketStep(
          isEditing: widget.isEditing,
          onFinished: () async {
            final creatorNotifier = ref.read(creatorProvider.notifier);
            final creatorState = ref.read(creatorProvider);

            if (creatorState.activeTeacher == null ||
                creatorState.activeTeacher!.id == null) {
              print("No active teacher found, trying to set from token");
              await creatorNotifier.setCreatorFromToken().then((success) {
                if (!success) {
                  showErrorToast("Session Expired, refreshing session");
                  return;
                }
              });
            }

            // create a new event
            if (widget.isEditing) {
              await ref
                  .read(eventCreationAndEditingProvider.notifier)
                  .updateClass(creatorState.activeTeacher!.id!);
            } else {
              // print the current user role

              await ref
                  .read(eventCreationAndEditingProvider.notifier)
                  .createClass(creatorState.activeTeacher!.id!);
            }

            if (eventState.errorMessage == null) {
              showSuccessToast(
                  "Event ${widget.isEditing ? "updated" : "created"} successfully");
              // if successful, pop the page

              context.goNamed(myEventsRoute);
              if (userAsync.value?.id != null) {
                ref
                    .read(teacherEventsProvider.notifier)
                    .fetchMyEvents(userAsync.value!.id!, isRefresh: true);
              }
            } else {
              // if not successful, show an error message
              showErrorToast(eventState.errorMessage!);
            }
          })
    ];

    // Define step titles
    const stepTitles = [
      "Event Details",
      "Description",
      "Occurrences",
      "Community",
      "Booking Information",
    ];

    return BasePage(
      makeScrollable: false,
      child: Column(
        children: [
          CompactProgressBar(
            currentStep: eventState.currentPage,
            totalSteps: pages.length,
            currentStepTitle: stepTitles[eventState.currentPage],
            onBackPressed: eventState.currentPage > 0
                ? () {
                    ref
                        .read(eventCreationAndEditingProvider.notifier)
                        .setPage(eventState.currentPage - 1);
                    setState(() {});
                  }
                : null,
            onClosePressed: () {
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: pages[eventState.currentPage],
          ),
        ],
      ),
    );
  }
}
