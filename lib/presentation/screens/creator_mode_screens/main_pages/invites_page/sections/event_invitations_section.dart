import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/components/cards/event_invitation_card.dart';
import 'package:acroworld/presentation/components/loading/shimmer_skeleton.dart';
import 'package:acroworld/presentation/components/sections/event_invitations_search_and_filter.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_invitations_provider.dart';
import 'package:acroworld/provider/riverpod_provider/pending_invites_badge_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventInvitationsSection extends ConsumerStatefulWidget {
  const EventInvitationsSection({super.key});

  @override
  ConsumerState<EventInvitationsSection> createState() =>
      _EventInvitationsSectionState();
}

class _EventInvitationsSectionState
    extends ConsumerState<EventInvitationsSection> {
  @override
  void initState() {
    super.initState();
    // Fetch initial invitations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = ref.read(userRiverpodProvider);
      userState.whenData((user) {
        if (user?.id != null) {
          // Fetch the filtered invitations directly
          ref.read(eventInvitationsProvider.notifier).fetchInvitations(
              isRefresh: true, userId: user!.id!, teacherId: _getTeacherId());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final invitationsState = ref.watch(eventInvitationsProvider);

    return Column(
      children: [
        // Search and filter
        EventInvitationsSearchAndFilter(
          searchQuery: invitationsState.searchQuery,
          selectedFilter: invitationsState.selectedFilter,
          onSearchChanged: (query) {
            ref
                .read(eventInvitationsProvider.notifier)
                .updateSearchQuery(query);
            // Debounce search
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                ref.read(eventInvitationsProvider.notifier).fetchInvitations(
                      searchQuery: query,
                      filter: invitationsState.selectedFilter,
                      isRefresh: true,
                      teacherId: _getTeacherId(),
                    );
              }
            });
          },
          onFilterChanged: (filter) {
            ref.read(eventInvitationsProvider.notifier).updateFilter(filter);
            final user = ref.read(userRiverpodProvider).value;
            ref.read(eventInvitationsProvider.notifier).fetchInvitations(
                  searchQuery: invitationsState.searchQuery,
                  filter: filter,
                  isRefresh: true,
                  userId: user?.id,
                  teacherId: _getTeacherId(),
                );
          },
          onSearchSubmitted: (query) {
            final user = ref.read(userRiverpodProvider).value;
            ref.read(eventInvitationsProvider.notifier).fetchInvitations(
                  searchQuery: query,
                  filter: invitationsState.selectedFilter,
                  isRefresh: true,
                  userId: user?.id,
                  teacherId: _getTeacherId(),
                );
          },
        ),
        // Invitations list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              final user = ref.read(userRiverpodProvider).value;
              return ref
                  .read(eventInvitationsProvider.notifier)
                  .fetchInvitations(
                    searchQuery: invitationsState.searchQuery,
                    filter: invitationsState.selectedFilter,
                    isRefresh: true,
                    userId: user?.id,
                    teacherId: _getTeacherId(),
                  );
            },
            child: _buildInvitationsList(invitationsState),
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationsList(EventInvitationsState state) {
    if (state.loading) {
      return _buildLoadingState();
    }

    if (state.error != null) {
      return _buildErrorState(state.error!);
    }

    if (state.invitations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.invitations.length +
          (state.canFetchMore ? 1 : 0) +
          1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == state.invitations.length) {
          // Load more button
          if (state.canFetchMore) {
            return GestureDetector(
              onTap: () =>
                  ref.read(eventInvitationsProvider.notifier).fetchMore(),
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

        if (index == state.invitations.length + (state.canFetchMore ? 1 : 0)) {
          // Bottom padding for floating button
          return const SizedBox(height: 80);
        }

        final invitation = state.invitations[index];
        final status = _statusFromHasAccepted(invitation);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: EventInvitationCard(
            invitation: invitation,
            status: status,
            onAccept: () => _onDecision(invitation, true),
            onReject: () => _onDecision(invitation, false),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerSkeleton(width: 200, height: 20),
                  const SizedBox(height: 8),
                  ShimmerSkeleton(width: 150, height: 16),
                  const SizedBox(height: 12),
                  ShimmerSkeleton(width: double.infinity, height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading invitations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref
                .read(eventInvitationsProvider.notifier)
                .fetchInvitations(isRefresh: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'No event invitations found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t been invited to any events yet',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _statusFromHasAccepted(ClassModel c) {
    // If any relation is pending, mark pending; else if any true, approved; else if any false, rejected
    if (c.classTeachers?.any((t) => t.hasAccepted == null) == true)
      return 'pending';
    if (c.classTeachers?.any((t) => t.hasAccepted == true) == true)
      return 'approved';
    if (c.classTeachers?.any((t) => t.hasAccepted == false) == true)
      return 'rejected';
    return 'pending';
  }

  Future<void> _onDecision(ClassModel c, bool accept) async {
    final user = ref.read(userRiverpodProvider).value;
    final teacherId = user?.teacherProfile?.id ?? user?.teacherId;
    if (teacherId == null || c.id == null) return;

    final ok = await ref
        .read(eventInvitationsProvider.notifier)
        .setInvitationAcceptance(
          classId: c.id!,
          teacherId: teacherId,
          hasAccepted: accept,
        );
    if (ok) {
      // Refresh invitations after accepting/rejecting
      await ref.read(eventInvitationsProvider.notifier).fetchInvitations(
            isRefresh: true,
            teacherId: _getTeacherId(),
          );

      // Also refresh the badge count
      final user = ref.read(userRiverpodProvider).value;
      if (user?.id != null && _getTeacherId() != null) {
        ref
            .read(pendingInvitesBadgeProvider.notifier)
            .fetchPendingCount(_getTeacherId()!, user!.id!);
      }
    }
  }

  String? _getTeacherId() {
    final creatorState = ref.read(creatorProvider);
    return creatorState.activeTeacher?.id;
  }
}
