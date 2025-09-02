import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_tile.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/my_events_page/modals/create_new_event_from_existing_modal.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


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

class _EventsByMeLoader extends ConsumerStatefulWidget {
  final String userId;
  const _EventsByMeLoader({required this.userId});

  @override
  ConsumerState<_EventsByMeLoader> createState() => _EventsByMeLoaderState();
}

class _EventsByMeLoaderState extends ConsumerState<_EventsByMeLoader> {
  var _didInit = false;

  @override
  void initState() {
    super.initState();

    // This is *outside* of build, so it's safe to call methods
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didInit) {
        ref.read(teacherEventsProvider.notifier)
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
    final eventsState = ref.watch(teacherEventsProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppDimensions.spacingMedium),
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
                ref.read(teacherEventsProvider.notifier).fetchMyEvents(widget.userId, isRefresh: true),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (eventsState.loading)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  if (!eventsState.loading &&
                      eventsState.myCreatedEvents.isNotEmpty)
                    _buildEventsList(eventsState),
                  if (!eventsState.loading && eventsState.myCreatedEvents.isEmpty)
                    _buildEmptyState(eventsState),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList(TeacherEventsState ev) {
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
                horizontal: AppDimensions.spacingSmall,
                vertical: AppDimensions.spacingExtraSmall,
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
            onTap: () => ref.read(teacherEventsProvider.notifier).fetchMore(widget.userId),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingSmall,
                vertical: AppDimensions.spacingExtraSmall,
              ),
              child: Text("Load more",
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        if (ev.isLoadingMyEvents)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingSmall,
              vertical: AppDimensions.spacingExtraSmall,
            ),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildEmptyState(TeacherEventsState ev) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You have not created any events yet",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppDimensions.spacingMedium),
            StandartButton(
              text: "Refresh",
              onPressed: () => ref.read(teacherEventsProvider.notifier).fetchMyEvents(widget.userId, isRefresh: true),
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
        pathParameters: {"urlSlug": cls.urlSlug!},
      );
    } else {
      showErrorToast("This event is not available anymore");
    }
  }
}
