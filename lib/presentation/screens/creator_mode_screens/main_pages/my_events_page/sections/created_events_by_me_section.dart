import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_tile.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/modals/create_new_event_from_existing_modal.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

class CreatedEventsByMeSection extends ConsumerStatefulWidget {
  const CreatedEventsByMeSection({super.key});

  @override
  ConsumerState<CreatedEventsByMeSection> createState() =>
      _CreatedEventsByMeSectionState();
}

class _CreatedEventsByMeSectionState
    extends ConsumerState<CreatedEventsByMeSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Read the current user ID from Riverpod
      final userId = ref.read(userRiverpodProvider).value?.id;
      if (userId == null) return;

      final myEventsProvider =
          provider.Provider.of<TeacherEventsProvider>(context, listen: false);

      if (myEventsProvider.myCreatedEvents.isEmpty &&
          !myEventsProvider.isInitialized) {
        try {
          myEventsProvider.userId = userId;
          myEventsProvider.fetchMyEvents(isRefresh: true);
        } catch (e, s) {
          CustomErrorHandler.captureException(e, stackTrace: s);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myEventsProvider =
        provider.Provider.of<TeacherEventsProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppPaddings.medium),
          child: StandartButton(
            text: "Create New Event",
            isFilled: true,
            onPressed: () => buildMortal(
              context,
              const CreateNewEventFromExistingModal(),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await myEventsProvider.fetchMyEvents(isRefresh: true);
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (myEventsProvider.loading)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (!myEventsProvider.loading &&
                      myEventsProvider.myCreatedEvents.isNotEmpty)
                    Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: myEventsProvider.myCreatedEvents.length,
                          itemBuilder: (context, index) {
                            final classObject =
                                myEventsProvider.myCreatedEvents[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPaddings.small,
                                vertical: AppPaddings.tiny,
                              ),
                              child: ClassTile(
                                classObject: classObject,
                                onTap: () => _onTap(
                                  classObject,
                                  context,
                                ),
                              ),
                            );
                          },
                        ),
                        if (myEventsProvider.canFetchMoreMyEvents)
                          GestureDetector(
                            onTap: () async {
                              await myEventsProvider.fetchMore();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPaddings.small,
                                vertical: AppPaddings.tiny,
                              ),
                              child: Text("Load more"),
                            ),
                          ),
                        if (myEventsProvider.isLoadingMyEvents)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPaddings.small,
                              vertical: AppPaddings.tiny,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  if (!myEventsProvider.loading &&
                      myEventsProvider.myCreatedEvents.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You have not created any events yet",
                            ),
                            const SizedBox(height: AppPaddings.medium),
                            StandartButton(
                              text: "Refresh",
                              onPressed: () async {
                                await myEventsProvider.fetchMyEvents(
                                    isRefresh: true);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onTap(ClassModel classObject, BuildContext context) {
    if (classObject.urlSlug != null || classObject.id != null) {
      context.pushNamed(
        singleEventWrapperRoute,
        pathParameters: {
          "urlSlug": classObject.urlSlug ?? "",
        },
        queryParameters: {
          "event": classObject.id,
        },
      );
    } else {
      showErrorToast("This event is not available anymore");
    }
  }
}
