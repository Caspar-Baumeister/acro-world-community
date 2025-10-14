import 'package:acroworld/presentation/components/dialogs/confirmation_dialog.dart';
import 'package:acroworld/presentation/components/progress/compact_progress_bar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/community_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/description_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/general_event_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/market_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/occurrences_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/questions_step.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_basic_info_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_booking_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_coordinator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateAndEditEventPage extends ConsumerStatefulWidget {
  const CreateAndEditEventPage({
    super.key,
    required this.isEditing,
    this.eventSlug,
  });

  // can either edit the existing event or use it as a template to create a new event
  final bool isEditing;
  final String? eventSlug;

  @override
  ConsumerState<CreateAndEditEventPage> createState() =>
      _CreateAndEditEventPageState();
}

class _CreateAndEditEventPageState
    extends ConsumerState<CreateAndEditEventPage> {
  @override
  void initState() {
    super.initState();

    // Load existing event data when editing
    if (widget.isEditing && widget.eventSlug != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(eventCreationCoordinatorProvider.notifier)
            .loadExistingClass(widget.eventSlug!, true);
      });
    }
  }

  void _validateGeneralStep() {
    final basicInfo = ref.read(eventBasicInfoProvider);
    final coordinator = ref.read(eventCreationCoordinatorProvider.notifier);

    // Use comprehensive validation
    final validations = coordinator.validateEventData();

    // Check specific fields for general step
    final titleError = validations['title'];
    final slugError = validations['slug'];
    final locationError = validations['location'];
    final locationNameError = validations['locationName'];
    final eventTypeError = validations['eventType'];
    final imageError = validations['image'];

    if (titleError != null) {
      showErrorToast(titleError);
      return;
    }
    if (slugError != null) {
      showErrorToast(slugError);
      return;
    }
    if (locationError != null) {
      showErrorToast(locationError);
      return;
    }
    if (locationNameError != null) {
      showErrorToast(locationNameError);
      return;
    }
    if (eventTypeError != null) {
      showErrorToast(eventTypeError);
      return;
    }
    if (imageError != null) {
      showErrorToast(imageError);
      return;
    }

    // Check slug validation (includes both format and availability)
    if (basicInfo.isSlugValid == false) {
      showErrorToast(basicInfo.errorMessage ??
          'Please check slug format and availability');
      return;
    }

    // All validations passed, advance to next step
    coordinator.setPage(1);
    setState(() {});
  }

  void _validateDescriptionStep() {
    final coordinator = ref.read(eventCreationCoordinatorProvider.notifier);

    // Use comprehensive validation for description
    final validations = coordinator.validateEventData();
    final descriptionError = validations['description'];

    if (descriptionError != null) {
      showErrorToast(descriptionError);
      return;
    }

    // Validation passed, advance to next step
    coordinator.setPage(2);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final coordinatorState = ref.watch(eventCreationCoordinatorProvider);

    final userAsync = ref.watch(userRiverpodProvider);

    final List<Widget> pages = [
      // Step 1: General Event Details
      GeneralEventStep(
        onFinished: () {
          ref.read(eventCreationCoordinatorProvider.notifier).setPage(1);
          setState(() {});
        },
      ),
      // Step 2: Description
      DescriptionStep(
        onFinished: () {
          ref.read(eventCreationCoordinatorProvider.notifier).setPage(2);
          setState(() {});
        },
      ),
      // Step 3: Questions
      QuestionsStep(
        onFinished: () {
          ref.read(eventCreationCoordinatorProvider.notifier).setPage(3);
          setState(() {});
        },
      ),
      // Step 4: Occurrences
      OccurrenceStep(
        onFinished: () {
          ref.read(eventCreationCoordinatorProvider.notifier).setPage(4);
          setState(() {});
        },
      ),
      // Step 5: Community
      CommunityStep(
        onFinished: () {
          ref.read(eventCreationCoordinatorProvider.notifier).setPage(5);
          setState(() {});
        },
      ),
      // Step 6: Market
      MarketStep(
          isEditing: widget.isEditing,
          onFinished: () async {
            final creatorNotifier = ref.read(creatorProvider.notifier);
            final creatorState = ref.read(creatorProvider);

            if (creatorState.activeTeacher == null ||
                creatorState.activeTeacher!.id == null) {
              await creatorNotifier.setCreatorFromToken().then((success) {
                if (!success) {
                  showErrorToast("Session Expired, refreshing session");
                  return;
                }
              });
            }

            // create a new event
            final coordinator =
                ref.read(eventCreationCoordinatorProvider.notifier);
            final success =
                await coordinator.saveEvent(creatorState.activeTeacher!.id!);

            if (success) {
              showSuccessToast(
                  "Event ${widget.isEditing ? "updated" : "created"} successfully");
              // if successful, pop the page

              context.goNamed(myEventsRoute);
              if (userAsync.value?.id != null) {
                ref
                    .read(teacherEventsProvider.notifier)
                    .fetchEvents(userAsync.value!.id!, isRefresh: true);
              }
            } else {
              // if not successful, show an error message
              final coordinatorState =
                  ref.read(eventCreationCoordinatorProvider);
              showErrorToast(
                  coordinatorState.errorMessage ?? 'Failed to save event');
            }
          })
    ];

    // Define step titles
    const stepTitles = [
      "Event Details",
      "Description",
      "Questions",
      "Occurrences",
      "Community",
      "Booking Information",
    ];

    return BasePage(
      makeScrollable: false,
      child: Column(
        children: [
          CompactProgressBar(
            currentStep: coordinatorState.currentPage,
            totalSteps: pages.length,
            currentStepTitle: stepTitles[coordinatorState.currentPage],
            isLoading: coordinatorState.isLoading,
            finalStepButtonText: widget.isEditing ? 'Update' : 'Create',
            onBackPressed: coordinatorState.currentPage > 0
                ? () {
                    ref
                        .read(eventCreationCoordinatorProvider.notifier)
                        .setPage(coordinatorState.currentPage - 1);
                    setState(() {});
                  }
                : null,
            onClosePressed: coordinatorState.currentPage == 0
                ? () async {
                    // Show warning dialog before closing
                    final shouldClose = await ConfirmationDialog.show(
                      context: context,
                      title: widget.isEditing
                          ? 'Discard Changes?'
                          : 'Cancel Event Creation?',
                      message: widget.isEditing
                          ? 'Are you sure you want to discard your changes? All unsaved changes will be lost.'
                          : 'Are you sure you want to cancel? All entered information will be lost.',
                      confirmText: 'Discard',
                      cancelText: 'Continue Editing',
                      icon: Icons.warning_amber_rounded,
                      isDestructive: true,
                    );

                    if (shouldClose == true && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            onNextPressed: coordinatorState.currentPage < pages.length - 1
                ? () {
                    // Trigger validation for the current step
                    // Each step will validate and call onFinished if valid
                    if (coordinatorState.currentPage == 0) {
                      // General step - validate required fields
                      _validateGeneralStep();
                    } else if (coordinatorState.currentPage == 1) {
                      // Description step - validate description
                      _validateDescriptionStep();
                    } else {
                      // Other steps - just advance
                      ref
                          .read(eventCreationCoordinatorProvider.notifier)
                          .setPage(coordinatorState.currentPage + 1);
                      setState(() {});
                    }
                  }
                : coordinatorState.isLoading
                    ? null // Disable button while loading
                    : () async {
                        // Final step - create the event
                        final booking = ref.read(eventBookingProvider);
                        final creatorNotifier =
                            ref.read(creatorProvider.notifier);
                        final creatorState = ref.read(creatorProvider);

                        // Validate payment setup
                        bool isStripeEnabled = creatorState.activeTeacher !=
                                null &&
                            creatorState.activeTeacher!.stripeId != null &&
                            creatorState.activeTeacher!.isStripeEnabled == true;

                        if (!isStripeEnabled &&
                            !booking.isCashAllowed &&
                            booking.bookingCategories.isNotEmpty) {
                          showErrorToast(
                              "Please enable Stripe or allow cash payments to create tickets");
                          return;
                        }

                        if (creatorState.activeTeacher == null ||
                            creatorState.activeTeacher!.id == null) {
                          await creatorNotifier
                              .setCreatorFromToken()
                              .then((success) {
                            if (!success) {
                              showErrorToast(
                                  "Session Expired, refreshing session");
                              return;
                            }
                          });
                        }

                        // Create the event
                        final coordinator =
                            ref.read(eventCreationCoordinatorProvider.notifier);
                        final success = await coordinator
                            .saveEvent(creatorState.activeTeacher!.id!);

                        if (success) {
                          showSuccessToast(
                              "Event ${widget.isEditing ? "updated" : "created"} successfully");

                          // Reset page to first step for next time
                          coordinator.setPage(0);

                          // Navigate back to My Events page
                          context.goNamed(myEventsRoute);

                          // Refresh the events list
                          final userAsync = ref.read(userRiverpodProvider);
                          if (userAsync.value?.id != null) {
                            await ref
                                .read(teacherEventsProvider.notifier)
                                .fetchEvents(userAsync.value!.id!,
                                    isRefresh: true);
                          }
                        } else {
                          // Show error message
                          final finalCoordinatorState =
                              ref.read(eventCreationCoordinatorProvider);
                          showErrorToast(finalCoordinatorState.errorMessage ??
                              'Failed to save event');
                        }
                      },
          ),
          Expanded(
            child: pages[coordinatorState.currentPage],
          ),
        ],
      ),
    );
  }
}
