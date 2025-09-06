import 'package:acroworld/presentation/components/cards/event_invitation_card.dart';
import 'package:acroworld/presentation/components/loading/shimmer_skeleton.dart';
import 'package:acroworld/presentation/components/sections/event_invitations_search_and_filter.dart';
import 'package:acroworld/provider/riverpod_provider/event_invitations_provider.dart';
import 'package:acroworld/provider/riverpod_provider/teacher_events_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventInvitationsSection extends ConsumerStatefulWidget {
  const EventInvitationsSection({super.key});

  @override
  ConsumerState<EventInvitationsSection> createState() => _EventInvitationsSectionState();
}

class _EventInvitationsSectionState extends ConsumerState<EventInvitationsSection> {
  @override
  void initState() {
    super.initState();
    // Fetch initial participating events and then filter them
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = ref.read(userRiverpodProvider);
      userState.whenData((user) {
        if (user?.id != null) {
          // First fetch the participating events
          ref.read(teacherEventsProvider.notifier).fetchMyEvents(
            user!.id!,
            myEvents: false,
            isRefresh: true,
          ).then((_) {
            // Then fetch the filtered invitations
            ref.read(eventInvitationsProvider.notifier).fetchInvitations(isRefresh: true);
          });
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
            ref.read(eventInvitationsProvider.notifier).updateSearchQuery(query);
            // Debounce search
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                ref.read(eventInvitationsProvider.notifier).fetchInvitations(
                  searchQuery: query,
                  filter: invitationsState.selectedFilter,
                  isRefresh: true,
                );
              }
            });
          },
          onFilterChanged: (filter) {
            ref.read(eventInvitationsProvider.notifier).updateFilter(filter);
            ref.read(eventInvitationsProvider.notifier).fetchInvitations(
              searchQuery: invitationsState.searchQuery,
              filter: filter,
              isRefresh: true,
            );
          },
          onSearchSubmitted: (query) {
            ref.read(eventInvitationsProvider.notifier).fetchInvitations(
              searchQuery: query,
              filter: invitationsState.selectedFilter,
              isRefresh: true,
            );
          },
        ),
        // Invitations list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(eventInvitationsProvider.notifier).fetchInvitations(
              searchQuery: invitationsState.searchQuery,
              filter: invitationsState.selectedFilter,
              isRefresh: true,
            ),
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
      itemCount: state.invitations.length + (state.canFetchMore ? 1 : 0) + 1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == state.invitations.length) {
          // Load more button
          if (state.canFetchMore) {
            return GestureDetector(
              onTap: () => ref.read(eventInvitationsProvider.notifier).fetchMore(),
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
        final status = _getInvitationStatus(invitation);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: EventInvitationCard(
            invitation: invitation,
            status: status,
            onTap: () => _onTap(invitation),
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
            onPressed: () => ref.read(eventInvitationsProvider.notifier).fetchInvitations(isRefresh: true),
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

  String _getInvitationStatus(dynamic invitation) {
    // Mock status based on some criteria
    // In reality, this would come from the invitation data
    final hash = invitation.id?.hashCode ?? 0;
    final statuses = ['approved', 'pending', 'rejected'];
    return statuses[hash.abs() % statuses.length];
  }

  void _onTap(dynamic invitation) {
    // TODO: Navigate to event details
    // This would be similar to the existing navigation logic
  }
}
