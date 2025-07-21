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

class CreatedEventsByMeSection extends ConsumerWidget {
  const CreatedEventsByMeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        CustomErrorHandler.captureException(e, stackTrace: st);
        return const Center(child: Text("Error loading user"));
      },
      data: (user) {
        if (user == null) {
          return const Center(child: Text("User not found"));
        }
        // Pass the userId down to the stateful loader
        return _EventsByMeLoader(userId: user.id!);
      },
    );
  }
}

class _EventsByMeLoader extends StatefulWidget {
  final String userId;
  const _EventsByMeLoader({required this.userId});

  @override
  State<_EventsByMeLoader> createState() => _EventsByMeLoaderState();
}

class _EventsByMeLoaderState extends State<_EventsByMeLoader> {
  var _didInit = false;

  @override
  void initState() {
    super.initState();

    // This is *outside* of build, so it's safe to call notifyListeners()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didInit) {
        final eventsProv =
            provider.Provider.of<TeacherEventsProvider>(context, listen: false);
        eventsProv
            .fetchMyEvents(widget.userId, isRefresh: true)
            .catchError((e, st) {
          CustomErrorHandler.captureException(e, stackTrace: st);
        });
        _didInit = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsProv = provider.Provider.of<TeacherEventsProvider>(context);
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
            onRefresh: () =>
                eventsProv.fetchMyEvents(widget.userId, isRefresh: true),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (eventsProv.loading)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  if (!eventsProv.loading &&
                      eventsProv.myCreatedEvents.isNotEmpty)
                    _buildEventsList(eventsProv),
                  if (!eventsProv.loading && eventsProv.myCreatedEvents.isEmpty)
                    _buildEmptyState(eventsProv),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList(TeacherEventsProvider ev) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ev.myCreatedEvents.length,
          itemBuilder: (ctx, i) {
            final cls = ev.myCreatedEvents[i];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPaddings.small,
                vertical: AppPaddings.tiny,
              ),
              child: ClassTile(
                classObject: cls,
                onTap: () => _onTap(cls),
              ),
            );
          },
        ),
        if (ev.canFetchMoreMyEvents)
          GestureDetector(
            onTap: () => ev.fetchMore(widget.userId),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPaddings.small,
                vertical: AppPaddings.tiny,
              ),
              child: Text("Load more"),
            ),
          ),
        if (ev.isLoadingMyEvents)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPaddings.small,
              vertical: AppPaddings.tiny,
            ),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildEmptyState(TeacherEventsProvider ev) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You have not created any events yet"),
            const SizedBox(height: AppPaddings.medium),
            StandartButton(
              text: "Refresh",
              onPressed: () => ev.fetchMyEvents(widget.userId, isRefresh: true),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(ClassModel cls) {
    if (cls.urlSlug != null) {
      context.pushNamed(
        singleEventWrapperRoute,
        pathParameters: {"urlSlug": cls.urlSlug ?? ""},
      );
    } else {
      showErrorToast("This event is not available anymore");
    }
  }
}
