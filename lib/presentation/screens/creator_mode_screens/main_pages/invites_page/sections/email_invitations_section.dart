import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/cards/modern_email_invitation_card.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/components/sections/email_invitations_search_and_filter.dart';
import 'package:acroworld/provider/riverpod_provider/invites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailInvitationsSection extends ConsumerStatefulWidget {
  const EmailInvitationsSection({super.key});

  @override
  ConsumerState<EmailInvitationsSection> createState() =>
      _EmailInvitationsSectionState();
}

class _EmailInvitationsSectionState
    extends ConsumerState<EmailInvitationsSection> {
  String _searchQuery = '';
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final invitesNotifier = ref.read(invitesProvider.notifier);
      final invitesState = ref.read(invitesProvider);

      if (invitesState.invites.isEmpty) {
        invitesNotifier.getInvitations(isRefresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final invitesState = ref.watch(invitesProvider);
    final invitesNotifier = ref.read(invitesProvider.notifier);

    return Column(
      children: [
        // Search and filter
        EmailInvitationsSearchAndFilter(
          searchQuery: _searchQuery,
          selectedFilter: _selectedFilter,
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          onFilterChanged: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
          onSearchSubmitted: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
        // Invitations list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await invitesNotifier.getInvitations(isRefresh: true);
            },
            child: _buildInvitationsList(invitesState, invitesNotifier),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildInvitationsList(
      InvitesState invitesState, InvitesNotifier invitesNotifier) {
    if (invitesState.loading) {
      return _buildLoadingState();
    }

    final filteredInvites = _getFilteredInvites(invitesState.invites);

    if (filteredInvites.isEmpty) {
      return _buildEmptyState(invitesNotifier);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredInvites.length +
          (invitesState.canFetchMore ? 1 : 0) +
          1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == filteredInvites.length) {
          // Load more button
          if (invitesState.canFetchMore) {
            return GestureDetector(
              onTap: () async {
                await invitesNotifier.fetchMore();
              },
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

        if (index ==
            filteredInvites.length + (invitesState.canFetchMore ? 1 : 0)) {
          // Bottom padding for floating button
          return const SizedBox(height: 80);
        }

        final invite = filteredInvites[index];
        return ModernEmailInvitationCard(
          invitation: invite,
          onTap: () {
            // TODO: Navigate to invitation details
          },
        );
      },
    );
  }

  List<InvitationModel> _getFilteredInvites(List<InvitationModel> invites) {
    return invites.where((invite) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final teacherName = invite.invitedUser?.name?.toLowerCase() ?? '';
        final email = invite.email?.toLowerCase() ?? '';
        final eventName = invite.classModel?.name?.toLowerCase() ?? '';

        final matchesSearch = teacherName.contains(query) ||
            email.contains(query) ||
            eventName.contains(query);
        if (!matchesSearch) return false;
      }

      // Status filter
      switch (_selectedFilter) {
        case 'confirmed':
          return invite.confirmationStatus.toLowerCase() == 'confirmed';
        case 'pending':
          return invite.confirmationStatus.toLowerCase() == 'pending';
        case 'rejected':
          return invite.confirmationStatus.toLowerCase() == 'rejected';
        case 'all':
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: const ListItemSkeleton(),
        );
      },
    );
  }

  Widget _buildEmptyState(InvitesNotifier invitesNotifier) {
    final hasFilters = _searchQuery.isNotEmpty || _selectedFilter != 'all';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.email_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters
                ? 'No invitations match your search'
                : 'No email invitations found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try adjusting your search or filters'
                : 'You haven\'t sent any email invitations yet',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ModernButton(
            text: hasFilters ? "Clear Filters" : "Refresh",
            onPressed: () async {
              if (hasFilters) {
                setState(() {
                  _searchQuery = '';
                  _selectedFilter = 'all';
                });
              } else {
                await invitesNotifier.getInvitations(isRefresh: true);
              }
            },
          ),
        ],
      ),
    );
  }
}
