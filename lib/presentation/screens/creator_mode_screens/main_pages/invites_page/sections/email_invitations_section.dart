import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/provider/riverpod_provider/invites_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailInvitationsSection extends ConsumerStatefulWidget {
  const EmailInvitationsSection({super.key});

  @override
  ConsumerState<EmailInvitationsSection> createState() => _EmailInvitationsSectionState();
}

class _EmailInvitationsSectionState extends ConsumerState<EmailInvitationsSection> {
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

    return RefreshIndicator(
      onRefresh: () async {
        await invitesNotifier.getInvitations(isRefresh: true);
      },
      child: _buildInvitationsList(invitesState, invitesNotifier),
    );
  }

  Widget _buildInvitationsList(InvitesState invitesState, InvitesNotifier invitesNotifier) {
    if (invitesState.loading) {
      return _buildLoadingState();
    }

    if (invitesState.invites.isEmpty) {
      return _buildEmptyState(invitesNotifier);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: invitesState.invites.length + (invitesState.canFetchMore ? 1 : 0) + 1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == invitesState.invites.length) {
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
        
        if (index == invitesState.invites.length + (invitesState.canFetchMore ? 1 : 0)) {
          // Bottom padding for floating button
          return const SizedBox(height: 80);
        }
        
        final invite = invitesState.invites[index];
        return _buildInvitationCard(invite);
      },
    );
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
            'No email invitations found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t sent any email invitations yet',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ModernButton(
            text: "Refresh",
            onPressed: () async {
              await invitesNotifier.getInvitations(isRefresh: true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationCard(InvitationModel invite) {
    if (invite.invitedUser == null && invite.email == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (invite.invitedUser?.name != null)
                  Text(
                    invite.invitedUser!.name!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                if (invite.invitedUser?.name == null && invite.email != null)
                  Text(
                    invite.email!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                SizedBox(height: AppDimensions.spacingExtraSmall),
                Text(
                  "Status: ${invite.confirmationStatus}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: invite.confirmationStatus.toLowerCase() == "pending"
                        ? Theme.of(context).colorScheme.error
                        : invite.confirmationStatus.toLowerCase() == "accepted"
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingExtraSmall),
                Text(
                  "Invited at: ${getDatedMMHHmm(DateTime.parse(invite.createdAt))}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (invite.classModel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.spacingExtraSmall),
                    child: Text(
                      "To teach at: ${invite.classModel!.name}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
