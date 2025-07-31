import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/modals/invite_by_email_modal.dart';
import 'package:acroworld/state/provider/invites_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvitesBody extends StatefulWidget {
  const InvitesBody({super.key});

  @override
  State<InvitesBody> createState() => _InvitesBodyState();
}

class _InvitesBodyState extends State<InvitesBody> {
  @override
  void initState() {
    InvitesProvider invitesProvider =
        Provider.of<InvitesProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      invitesProvider.getInvitations(isRefresh: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InvitesProvider invitesProvider = Provider.of<InvitesProvider>(context);
    return Column(
      children: [
        SizedBox(height: AppDimensions.spacingMedium),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await invitesProvider.getInvitations(isRefresh: true);
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (invitesProvider.loading)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (!invitesProvider.loading &&
                      invitesProvider.invites.isNotEmpty)
                    Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              InvitationModel invite =
                                  invitesProvider.invites[index];
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
                                                            .extension<
                                                                AppCustomColors>()!
                                                            .warning
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
                            itemCount: invitesProvider.invites.length),
                        if (invitesProvider.canFetchMore)
                          GestureDetector(
                            onTap: () async {
                              await invitesProvider.fetchMore();
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
                        if (invitesProvider.loading)
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
                  if (!invitesProvider.loading &&
                      invitesProvider.invites.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No invites found",
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: AppDimensions.spacingMedium),
                            StandartButton(
                              text: "Refresh",
                              onPressed: () async {
                                await invitesProvider.getInvitations(
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
        StandartButton(
            text: "Invite by Email",
            isFilled: true,
            onPressed: () => buildMortal(context, const InviteByEmailModal())),
        SizedBox(height: AppDimensions.spacingMedium),
      ],
    );
  }
}
