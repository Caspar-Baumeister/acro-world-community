import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
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

/// Top‐level watcher: waits for the Riverpod user, then hands off to the loader.
class ParticipatedEventsSection extends ConsumerWidget {
  const ParticipatedEventsSection({super.key});

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
        // Pass the non-null user ID into our stateful loader widget.
        return _ParticipatedEventsLoader(userId: user.id!);
      },
    );
  }
}

/// Stateful loader + UI for “participated events”
class _ParticipatedEventsLoader extends StatefulWidget {
  final String userId;
  const _ParticipatedEventsLoader({required this.userId});

  @override
  State<_ParticipatedEventsLoader> createState() =>
      _ParticipatedEventsLoaderState();
}

class _ParticipatedEventsLoaderState extends State<_ParticipatedEventsLoader> {
  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    // Schedule the initial fetch after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didInit) {
        final eventsProv = provider.Provider.of<TeacherEventsProvider>(
          context,
          listen: false,
        );
        eventsProv
            .fetchMyEvents(
          widget.userId,
          myEvents: false,
          isRefresh: true,
        )
            .catchError((e, st) {
          CustomErrorHandler.captureException(e, stackTrace: st);
        });
        _didInit = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsProv =
        provider.Provider.of<TeacherEventsProvider>(context, listen: true);

    return RefreshIndicator(
      onRefresh: () => eventsProv.fetchMyEvents(
        widget.userId,
        myEvents: false,
        isRefresh: true,
      ),
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
                eventsProv.myParticipatingEvents.isNotEmpty)
              _buildEventsList(eventsProv),
            if (!eventsProv.loading && eventsProv.myParticipatingEvents.isEmpty)
              _buildEmptyState(eventsProv),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(TeacherEventsProvider ev) {
    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ev.myParticipatingEvents.length,
          itemBuilder: (context, index) {
            final cls = ev.myParticipatingEvents[index];
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
        if (ev.canFetchMoreParticipatingEvents)
          GestureDetector(
            onTap: () => ev.fetchMore(widget.userId, myEvents: false),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPaddings.small,
                vertical: AppPaddings.tiny,
              ),
              child: Text("Load more"),
            ),
          ),
        if (ev.isLoadingParticipatingEvents)
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
            const Text("You have not participated in any events yet"),
            const SizedBox(height: AppPaddings.medium),
            StandartButton(
              text: "Refresh",
              onPressed: () => ev.fetchMyEvents(
                widget.userId,
                myEvents: false,
                isRefresh: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(ClassModel cls) {
    if (cls.urlSlug != null || cls.id != null) {
      context.pushNamed(
        singleEventWrapperRoute,
        pathParameters: {"urlSlug": cls.urlSlug ?? ""},
        queryParameters: {"event": cls.id},
      );
    } else {
      showErrorToast("This event is not available anymore");
    }
  }
}
