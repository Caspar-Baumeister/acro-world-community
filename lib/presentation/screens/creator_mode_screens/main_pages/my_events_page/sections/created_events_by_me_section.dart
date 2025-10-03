import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/loading/shimmer_skeleton.dart';
import 'package:acroworld/presentation/components/sections/events_search_and_filter.dart';
import 'package:acroworld/presentation/components/tiles/event_tiles/class_tile.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreatedEventsByMeSection extends ConsumerWidget {
  const CreatedEventsByMeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () => const Center(
        child: ProfileSkeleton(),
      ),
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
  String _searchQuery = '';
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();

    // This is *outside* of build, so it's safe to call methods
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didInit) {
        ref
            .read(teacherEventsProvider.notifier)
            .fetchEvents(widget.userId, isRefresh: true)
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
        // Search and filter
        EventsSearchAndFilter(
          searchQuery: _searchQuery,
          selectedFilter: _selectedFilter,
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
            // Debounce search
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                _filterEvents();
              }
            });
          },
          onFilterChanged: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
            _filterEvents();
          },
          onSearchSubmitted: (query) {
            setState(() {
              _searchQuery = query;
            });
            _filterEvents();
          },
        ),
        // Events list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref
                .read(teacherEventsProvider.notifier)
                .fetchEvents(widget.userId, isRefresh: true),
            child: _buildEventsContent(eventsState),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildEventsContent(TeacherEventsState eventsState) {
    if (eventsState.loading) {
      return _buildLoadingState();
    }

    final filteredEvents = _getFilteredEvents(eventsState.events);

    if (filteredEvents.isEmpty) {
      return _buildEmptyState(eventsState);
    }

    return _buildEventsList(eventsState, filteredEvents);
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: EventCardSkeleton(),
        );
      },
    );
  }

  Widget _buildEventsList(
      TeacherEventsState ev, List<ClassModel> filteredEvents) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredEvents.length +
          (ev.canFetchMore ? 1 : 0) +
          1, // +1 for bottom padding
      itemBuilder: (ctx, i) {
        if (i == filteredEvents.length) {
          // Load more button
          if (ev.canFetchMore) {
            return GestureDetector(
              onTap: () => ref
                  .read(teacherEventsProvider.notifier)
                  .fetchMore(widget.userId),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    "Load more",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        if (i == filteredEvents.length + (ev.canFetchMore ? 1 : 0)) {
          // Bottom padding for floating button
          return const SizedBox(height: 80);
        }

        final cls = filteredEvents[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ClassTile(
            classObject: cls,
            onTap: () => _onTap(cls),
          ),
        );
      },
    );
  }

  List<ClassModel> _getFilteredEvents(List<ClassModel> events) {
    var filtered = events.where((event) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesSearch =
            event.name?.toLowerCase().contains(query) == true ||
                event.locationName?.toLowerCase().contains(query) == true ||
                event.city?.toLowerCase().contains(query) == true ||
                event.country?.toLowerCase().contains(query) == true;
        if (!matchesSearch) return false;
      }

      // Status filter - using amountUpcomingEvents as a proxy for active status
      // Only Active or All
      if (_selectedFilter == 'active') {
        return (event.amountUpcomingEvents ?? 0) > 0;
      }
      return true; // 'all'
    }).toList();

    return filtered;
  }

  void _filterEvents() {
    // This will trigger a rebuild with filtered events
    setState(() {});
  }

  Widget _buildEmptyState(TeacherEventsState ev) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedFilter != 'all'
                ? "No events match your search"
                : "You have not created any events yet",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedFilter != 'all'
                ? "Try adjusting your search or filters"
                : "Create your first event to get started",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ModernButton(
            text: _searchQuery.isNotEmpty || _selectedFilter != 'all'
                ? "Clear Filters"
                : "Refresh",
            onPressed: () {
              if (_searchQuery.isNotEmpty || _selectedFilter != 'all') {
                setState(() {
                  _searchQuery = '';
                  _selectedFilter = 'all';
                });
              } else {
                ref
                    .read(teacherEventsProvider.notifier)
                    .fetchEvents(widget.userId, isRefresh: true);
              }
            },
          ),
        ],
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
