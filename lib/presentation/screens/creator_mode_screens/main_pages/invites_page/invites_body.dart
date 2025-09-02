import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/modals/invite_by_email_modal.dart';
import 'package:acroworld/provider/riverpod_provider/invites_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvitesBody extends ConsumerStatefulWidget {
  const InvitesBody({super.key});

  @override
  ConsumerState<InvitesBody> createState() => _InvitesBodyState();
}

class _InvitesBodyState extends ConsumerState<InvitesBody> {
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
        SizedBox(height: AppDimensions.spacingMedium),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await invitesNotifier.getInvitations(isRefresh: true);
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (invitesState.loading)
                    Column(
                      children: List.generate(
                        5, // Show 5 skeleton items
                        (index) => const ListItemSkeleton(),
                      ),
                    ),

                  // if (!invitesProvider.loading && invitesProvider.invites.isNotEmpty)
                  if (true)
                    Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              InvitationModel invite =
                                  invitesState.invites[index];
                              if (invite.invitedUser == null &&
                                  invite.email == null) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.spacingMedium,
                                    vertical: AppDimensions.spacingSmall),
                                // InvitesTile
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      AppDimensions.spacingMedium),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusSmall),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow
                                            .withOpacity(0.5),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppDimensions.spacingSmall),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (invite.invitedUser?.name != null)
                                            Text(
                                              invite.invitedUser!.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          if (invite.invitedUser?.name ==
                                                  null &&
                                              invite.email != null)
                                            Text(
                                              invite.email!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          SizedBox(
                                              height: AppDimensions
                                                  .spacingExtraSmall),
                                          Text(
                                            "Status: ${invite.confirmationStatus}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: invite
                                                                .confirmationStatus
                                                                .toLowerCase() ==
                                                            "pending"
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .error
                                                        : invite.confirmationStatus
                                                                    .toLowerCase() ==
                                                                "accepted"
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .error),
                                          ),
                                          const SizedBox(
                                              height: AppDimensions
                                                  .spacingExtraSmall),
                                          Text(
                                            "Invited at: ${getDatedMMHHmm(DateTime.parse(invite.createdAt))}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          if (invite.classModel != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: AppDimensions
                                                      .spacingExtraSmall),
                                              child: Text(
                                                "To teach at: ${invite.classModel!.name}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: invitesState.invites.length),
                        if (invitesState.canFetchMore)
                          GestureDetector(
                            onTap: () async {
                              await invitesNotifier.fetchMore();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spacingSmall,
                                  vertical: AppDimensions.spacingExtraSmall),
                              child: Text(
                                "Load more",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        if (invitesState.loading)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingSmall,
                                vertical: AppDimensions.spacingExtraSmall),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  if (!invitesState.loading && invitesState.invites.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No invites found",
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: AppDimensions.spacingMedium),
                            ModernButton(
                              text: "Refresh",
                              onPressed: () async {
                                await invitesNotifier.getInvitations(
                                    isRefresh: true);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spacingSmall),
        ModernButton(
            text: "Invite by Email",
            isFilled: true,
            onPressed: () => buildMortal(context, const InviteByEmailModal())),
        SizedBox(height: AppDimensions.spacingMedium),
      ],
    );
  }
}
