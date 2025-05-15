import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_tile.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ParticipatedEventsSection extends StatefulWidget {
  const ParticipatedEventsSection({super.key});

  @override
  State<ParticipatedEventsSection> createState() =>
      _ParticipatedEventsSectionState();
}

class _ParticipatedEventsSectionState extends State<ParticipatedEventsSection> {
  // initialize teacherEventsProvider
  @override
  void initState() {
    super.initState();
    TeacherEventsProvider teacherEventsProvider =
        Provider.of<TeacherEventsProvider>(context, listen: false);
    if (teacherEventsProvider.myParticipatingEvents.isEmpty) {
      teacherEventsProvider.userId =
          Provider.of<UserProvider>(context, listen: false).activeUser!.id!;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        teacherEventsProvider.fetchMyEvents(myEvents: false, isRefresh: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TeacherEventsProvider teacherEventsProvider =
        Provider.of<TeacherEventsProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        await teacherEventsProvider.fetchMyEvents(myEvents: false);
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (teacherEventsProvider.loading)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (!teacherEventsProvider.loading &&
                teacherEventsProvider.myParticipatingEvents.isNotEmpty)
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
                              classObject: teacherEventsProvider
                                  .myParticipatingEvents[index],
                              onTap: () => onTap(
                                  teacherEventsProvider
                                      .myParticipatingEvents[index],
                                  context)),
                        );
                      },
                      itemCount:
                          teacherEventsProvider.myParticipatingEvents.length),
                  if (teacherEventsProvider.canFetchMoreParticipatingEvents)
                    GestureDetector(
                      onTap: () async {
                        await teacherEventsProvider.fetchMore(myEvents: false);
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
                  if (teacherEventsProvider.isLoadingParticipatingEvents)
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
            if (!teacherEventsProvider.loading &&
                teacherEventsProvider.myParticipatingEvents.isEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("You have not created any events yet"),
                      const SizedBox(height: AppPaddings.medium),
                      StandartButton(
                        text: "Refresh",
                        onPressed: () async {
                          await teacherEventsProvider.fetchMyEvents(
                              myEvents: false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onTap(ClassModel classObject, BuildContext context) {
    if (classObject.urlSlug != null || classObject.id != null) {
      context.goNamed(
        singleEventWrapperRoute,
        pathParameters: {
          "urlSlug": classObject.urlSlug ?? "",
          "classEventId": classObject.id ?? "",
        },
      );
    } else {
      showErrorToast("This event is not available anymore");
    }
  }
}
