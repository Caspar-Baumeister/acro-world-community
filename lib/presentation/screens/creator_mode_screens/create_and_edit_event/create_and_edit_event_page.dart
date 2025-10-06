import 'package:acroworld/presentation/components/progress/compact_progress_bar.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/community_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/description_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/general_event_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/market_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/occurrences_step.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/questions_step.dart';
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
            .read(eventCreationAndEditingProvider.notifier)
            .setClassFromExisting(widget.eventSlug!, true, false);
      });
    }
  }

  void _validateGeneralStep() {
    final eventState = ref.read(eventCreationAndEditingProvider);
    final notifier = ref.read(eventCreationAndEditingProvider.notifier);

    // Use comprehensive validation
    final validations = notifier.validateEventData();

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
    if (eventState.isSlugValid == false) {
      showErrorToast(eventState.errorMessage ??
          'Please check slug format and availability');
      return;
    }

    // All validations passed, advance to next step
    notifier.setPage(1);
    setState(() {});
  }

  void _validateDescriptionStep() {
    final notifier = ref.read(eventCreationAndEditingProvider.notifier);

    // Use comprehensive validation for description
    final validations = notifier.validateEventData();
    final descriptionError = validations['description'];

    if (descriptionError != null) {
      showErrorToast(descriptionError);
      return;
    }

    // Validation passed, advance to next step
    notifier.setPage(2);
    setState(() {});
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
      // Step 3: Questions
      QuestionsStep(
        onFinished: () {
          ref.read(eventCreationAndEditingProvider.notifier).setPage(3);
          setState(() {});
        },
      ),
      // Step 4: Occurrences
      OccurrenceStep(
        onFinished: () {
          ref.read(eventCreationAndEditingProvider.notifier).setPage(4);
          setState(() {});
        },
      ),
      // Step 5: Community
      CommunityStep(
        onFinished: () {
          ref.read(eventCreationAndEditingProvider.notifier).setPage(5);
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
                    .fetchEvents(userAsync.value!.id!, isRefresh: true);
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
            currentStep: eventState.currentPage,
            totalSteps: pages.length,
            currentStepTitle: stepTitles[eventState.currentPage],
            isLoading: eventState.isLoading,
            finalStepButtonText: widget.isEditing ? 'Update' : 'Create',
            onBackPressed: eventState.currentPage > 0
                ? () {
                    ref
                        .read(eventCreationAndEditingProvider.notifier)
                        .setPage(eventState.currentPage - 1);
                    setState(() {});
                  }
                : null,
            onClosePressed: eventState.currentPage == 0
                ? () {
                    Navigator.of(context).pop();
                  }
                : null,
            onNextPressed: eventState.currentPage < pages.length - 1
                ? () {
                    // Trigger validation for the current step
                    // Each step will validate and call onFinished if valid
                    if (eventState.currentPage == 0) {
                      // General step - validate required fields
                      _validateGeneralStep();
                    } else if (eventState.currentPage == 1) {
                      // Description step - validate description
                      _validateDescriptionStep();
                    } else {
                      // Other steps - just advance
                      ref
                          .read(eventCreationAndEditingProvider.notifier)
                          .setPage(eventState.currentPage + 1);
                      setState(() {});
                    }
                  }
                : eventState.isLoading
                    ? null // Disable button while loading
                    : () async {
                        // Final step - create the event
                        print(
                            "🎯 DEBUG: Create button pressed - starting event creation flow");
                        final eventState =
                            ref.read(eventCreationAndEditingProvider);
                        final creatorNotifier =
                            ref.read(creatorProvider.notifier);
                        final creatorState = ref.read(creatorProvider);

                        print("🎯 DEBUG: Event state before creation:");
                        print("🎯 DEBUG: - Title: ${eventState.title}");
                        print(
                            "🎯 DEBUG: - Description: ${eventState.description}");
                        print("🎯 DEBUG: - Slug: ${eventState.slug}");
                        print("🎯 DEBUG: - Location: ${eventState.location}");
                        print(
                            "🎯 DEBUG: - Event Type: ${eventState.eventType}");
                        print(
                            "🎯 DEBUG: - Recurring Patterns: ${eventState.recurringPatterns.length}");
                        print(
                            "🎯 DEBUG: - Booking Categories: ${eventState.bookingCategories.length}");
                        print(
                            "🎯 DEBUG: - Pending Teachers: ${eventState.pendingInviteTeachers.length}");

                        // Validate payment setup
                        bool isStripeEnabled = creatorState.activeTeacher !=
                                null &&
                            creatorState.activeTeacher!.stripeId != null &&
                            creatorState.activeTeacher!.isStripeEnabled == true;

                        print("🎯 DEBUG: Payment validation:");
                        print("🎯 DEBUG: - Stripe enabled: $isStripeEnabled");
                        print(
                            "🎯 DEBUG: - Cash allowed: ${eventState.isCashAllowed}");
                        print(
                            "🎯 DEBUG: - Booking categories: ${eventState.bookingCategories.length}");

                        if (!isStripeEnabled &&
                            !eventState.isCashAllowed &&
                            eventState.bookingCategories.isNotEmpty) {
                          print(
                              "❌ DEBUG: Payment validation failed - no payment method");
                          showErrorToast(
                              "Please enable Stripe or allow cash payments to create tickets");
                          return;
                        }

                        if (creatorState.activeTeacher == null ||
                            creatorState.activeTeacher!.id == null) {
                          print(
                              "🎯 DEBUG: No active teacher found, trying to set from token");
                          await creatorNotifier
                              .setCreatorFromToken()
                              .then((success) {
                            if (!success) {
                              print(
                                  "❌ DEBUG: Failed to set creator from token");
                              showErrorToast(
                                  "Session Expired, refreshing session");
                              return;
                            }
                          });
                        }

                        print(
                            "🎯 DEBUG: Creator ID: ${creatorState.activeTeacher?.id}");

                        // Create the event
                        print("🎯 DEBUG: Starting event creation...");
                        if (widget.isEditing) {
                          print("🎯 DEBUG: Updating existing event");
                          await ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .updateClass(creatorState.activeTeacher!.id!);
                        } else {
                          print("🎯 DEBUG: Creating new event");
                          await ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .createClass(creatorState.activeTeacher!.id!);
                        }
                        print("🎯 DEBUG: Event creation call completed");

                        // Wait a moment for state to update
                        await Future.delayed(const Duration(milliseconds: 100));

                        // Check if creation was successful
                        final finalEventState =
                            ref.read(eventCreationAndEditingProvider);

                        print(
                            "🎯 DEBUG: Checking creation result after delay:");
                        print(
                            "🎯 DEBUG: - Error message: ${finalEventState.errorMessage}");
                        print(
                            "🎯 DEBUG: - Is loading: ${finalEventState.isLoading}");
                        print(
                            "🎯 DEBUG: - State toString: ${finalEventState.toString()}");

                        if (finalEventState.errorMessage == null) {
                          print("✅ DEBUG: Event creation successful!");
                          showSuccessToast(
                              "Event ${widget.isEditing ? "updated" : "created"} successfully");

                          // Navigate back to My Events page
                          print("🎯 DEBUG: Navigating to My Events page");
                          try {
                            context.goNamed(myEventsRoute);
                            print("🎯 DEBUG: Navigation successful");
                          } catch (e) {
                            print("❌ DEBUG: Navigation failed: $e");
                          }

                          // Refresh the events list
                          final userAsync = ref.read(userRiverpodProvider);
                          print(
                              "🎯 DEBUG: User async value: ${userAsync.value?.id}");
                          if (userAsync.value?.id != null) {
                            print(
                                "🎯 DEBUG: Refreshing events list for user: ${userAsync.value!.id}");
                            try {
                              await ref
                                  .read(teacherEventsProvider.notifier)
                                  .fetchEvents(userAsync.value!.id!,
                                      isRefresh: true);
                              print("🎯 DEBUG: Events list refresh completed");
                            } catch (e) {
                              print("❌ DEBUG: Events list refresh failed: $e");
                            }
                          } else {
                            print(
                                "❌ DEBUG: No user ID found, cannot refresh events list");
                          }
                        } else {
                          // Show error message
                          print(
                              "❌ DEBUG: Event creation failed: ${finalEventState.errorMessage}");
                          showErrorToast(finalEventState.errorMessage!);
                        }
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
