import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/tiles/event_tiles/class_tile.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/routes/page_routes/single_class_id_wrapper_page_route.dart';
import 'package:acroworld/screens/modals/create_new_event_from_existing_modal.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatedEventsByMeSection extends StatefulWidget {
  const CreatedEventsByMeSection({super.key});

  @override
  State<CreatedEventsByMeSection> createState() =>
      _CreatedEventsByMeSectionState();
}

class _CreatedEventsByMeSectionState extends State<CreatedEventsByMeSection> {
  // initialize MyEventsProvider
  @override
  void initState() {
    super.initState();

    TeacherEventsProvider myEventsProvider =
        Provider.of<TeacherEventsProvider>(context, listen: false);
    if (myEventsProvider.myCreatedEvents.isEmpty) {
      myEventsProvider.userId =
          Provider.of<UserProvider>(context, listen: false).activeUser!.id!;
      myEventsProvider.fetchMyEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    TeacherEventsProvider myEventsProvider =
        Provider.of<TeacherEventsProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppPaddings.medium),
          child: StandardButton(
              text: "Create New Event",
              isFilled: true,
              onPressed: () => buildMortal(
                  context, const CreateNewEventFromExistingModal())),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await myEventsProvider.fetchMyEvents();
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
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppPaddings.small,
                                    vertical: AppPaddings.tiny),
                                child: ClassTile(
                                    classObject:
                                        myEventsProvider.myCreatedEvents[index],
                                    onTap: () => onTap(
                                        myEventsProvider.myCreatedEvents[index],
                                        context)),
                              );
                            },
                            itemCount: myEventsProvider.myCreatedEvents.length),
                        if (myEventsProvider.canFetchMoreMyEvents)
                          GestureDetector(
                            onTap: () async {
                              await myEventsProvider.fetchMore();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppPaddings.small,
                                  vertical: AppPaddings.tiny),
                              child: Text(
                                "Load more",
                              ),
                            ),
                          ),
                        if (myEventsProvider.isLoadingMyEvents)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppPaddings.small,
                                vertical: AppPaddings.tiny),
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
                            const Text("You have not created any events yet"),
                            const SizedBox(height: AppPaddings.medium),
                            StandardButton(
                              text: "Refresh",
                              onPressed: () async {
                                await myEventsProvider.fetchMyEvents();
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

  void onTap(ClassModel classObject, BuildContext context) {
    if (classObject.urlSlug != null || classObject.id != null) {
      Navigator.of(context).push(
        SingleEventIdWrapperPageRoute(
          urlSlug: classObject.urlSlug,
          classId: classObject.id,
          isCreator: true,
        ),
      );
    } else {
      showErrorToast("This event is not available anymore");
    }
  }
}
