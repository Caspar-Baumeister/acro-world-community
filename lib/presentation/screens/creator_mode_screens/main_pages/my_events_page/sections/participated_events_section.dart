import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_tile.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/teacher_event_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

class ParticipatedEventsSection extends ConsumerStatefulWidget {
  const ParticipatedEventsSection({super.key});

  @override
  ConsumerState<ParticipatedEventsSection> createState() =>
      _ParticipatedEventsSectionState();
}

class _ParticipatedEventsSectionState
    extends ConsumerState<ParticipatedEventsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(userRiverpodProvider).value?.id;
      if (userId == null) return;

      final teacherEventsProvider =
          provider.Provider.of<TeacherEventsProvider>(context, listen: false);
      if (teacherEventsProvider.myParticipatingEvents.isEmpty) {
        teacherEventsProvider.userId = userId;
        teacherEventsProvider.fetchMyEvents(
          myEvents: false,
          isRefresh: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final teacherEventsProvider =
        provider.Provider.of<TeacherEventsProvider>(context);

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
                    itemCount:
                        teacherEventsProvider.myParticipatingEvents.length,
                    itemBuilder: (context, index) {
                      final classObject =
                          teacherEventsProvider.myParticipatingEvents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPaddings.small,
                          vertical: AppPaddings.tiny,
                        ),
                        child: ClassTile(
                          classObject: classObject,
                          onTap: () => _onTap(classObject, context),
                        ),
                      );
                    },
                  ),
                  if (teacherEventsProvider.canFetchMoreParticipatingEvents)
                    GestureDetector(
                      onTap: () async {
                        await teacherEventsProvider.fetchMore(myEvents: false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPaddings.small,
                          vertical: AppPaddings.tiny,
                        ),
                        child: Text("Load more"),
                      ),
                    ),
                  if (teacherEventsProvider.isLoadingParticipatingEvents)
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
