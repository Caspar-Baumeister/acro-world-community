import 'package:acroworld/presentation/components/custom_easy_stepper.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/community_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/general_event_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/market_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/occurrences_step.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/provider/user_role_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

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
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        provider.Provider.of<EventCreationAndEditingProvider>(context);

    final userAsync = ref.watch(userRiverpodProvider);

    final List<Widget> pages = [
      // second page
      GeneralEventStep(
        onFinished: () {
          eventCreationAndEditingProvider.setPage(1);
          setState(() {});
        },
      ),
      OccurrenceStep(
        onFinished: () {
          eventCreationAndEditingProvider.setPage(2);
          setState(() {});
        },
      ),
      CommunityStep(
        onFinished: () {
          eventCreationAndEditingProvider.setPage(3);
          setState(() {});
        },
      ),
      MarketStep(
          isEditing: widget.isEditing,
          onFinished: () async {
            final creatorProvider =
                provider.Provider.of<CreatorProvider>(context, listen: false);

            if (creatorProvider.activeTeacher == null ||
                creatorProvider.activeTeacher!.id == null) {
              await creatorProvider.setCreatorFromToken().then((success) {
                if (!success) {
                  showErrorToast("Session Expired, refreshing session");
                  return;
                }
              });
            }

            // create a new event
            if (widget.isEditing) {
              await eventCreationAndEditingProvider
                  .updateClass(creatorProvider.activeTeacher!.id!);
            } else {
              // print the current user role
              print(
                  "Current user role: ${provider.Provider.of<UserRoleProvider>(context, listen: false).isCreator}");
              print(
                  "Tokensigleton is creator: ${TokenSingletonService().getUserRoles()}");
              await eventCreationAndEditingProvider
                  .createClass(creatorProvider.activeTeacher!.id!);
            }

            if (eventCreationAndEditingProvider.errorMessage == null) {
              showSuccessToast(
                  "Event ${widget.isEditing ? "updated" : "created"} successfully");
              // if successful, pop the page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(myEventsRoute);
                if (userAsync.value?.id != null) {
                  provider.Provider.of<TeacherEventsProvider>(context,
                          listen: false)
                      .fetchMyEvents(userAsync.value!.id!, isRefresh: true);
                }
              });
            } else {
              // if not successful, show an error message
              showErrorToast(eventCreationAndEditingProvider.errorMessage!);
            }
          })
    ];

    return BasePage(
      makeScrollable: false,
      child: Column(
        children: [
          Stack(
            children: [
              CustomEasyStepper(
                  activeStep: eventCreationAndEditingProvider.currentPage,
                  onStepReached: (_) {},
                  setStep: (index) {
                    if (index < eventCreationAndEditingProvider.currentPage) {
                      eventCreationAndEditingProvider.setPage(index);
                      setState(() {});
                    }
                  },
                  steps: const [
                    "General",
                    "Occurences",
                    "Community",
                    "Booking",
                  ]),
              Positioned(
                left: 0,
                top: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: AppDimensions.iconSizeLarge,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: pages[eventCreationAndEditingProvider.currentPage],
          ),
        ],
      ),
    );
  }
}
