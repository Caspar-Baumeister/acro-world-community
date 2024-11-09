import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/invites_page/modals/invite_by_email_modal.dart';
import 'package:acroworld/state/provider/invites_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
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
        SizedBox(height: AppPaddings.medium),
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
                                    horizontal: AppPaddings.medium,
                                    vertical: AppPaddings.small),
                                // InvitesTile
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(AppPaddings.medium),
                                  decoration: BoxDecoration(
                                    color: CustomColors.backgroundColor,
                                    borderRadius: AppBorders.smallRadius,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
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
                                          vertical: AppPaddings.small),
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
                                          const SizedBox(
                                              height: AppPaddings.tiny),
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
                                                        ? Colors.orange
                                                        : invite.confirmationStatus
                                                                    .toLowerCase() ==
                                                                "accepted"
                                                            ? Colors.green
                                                            : Colors.red),
                                          ),
                                          const SizedBox(
                                              height: AppPaddings.tiny),
                                          Text(
                                            "Invited at: ${getDatedMMHHmm(DateTime.parse(invite.createdAt))}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          if (invite.classModel != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: AppPaddings.tiny),
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppPaddings.small,
                                  vertical: AppPaddings.tiny),
                              child: Text(
                                "Load more",
                              ),
                            ),
                          ),
                        if (invitesProvider.loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppPaddings.small,
                                vertical: AppPaddings.tiny),
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
                            const Text("No invites found"),
                            const SizedBox(height: AppPaddings.medium),
                            StandardButton(
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
        SizedBox(height: AppPaddings.small),
        StandardButton(
            text: "Invite by Email",
            isFilled: true,
            onPressed: () => buildMortal(context, const InviteByEmailModal())),
        SizedBox(height: AppPaddings.medium),
      ],
    );
  }
}
