import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_stripe_connect_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_switch_to_user_mode_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/edit_creator_profile_button.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatorProfileBody extends StatelessWidget {
  const CreatorProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    CreatorProvider creatorProvider = Provider.of<CreatorProvider>(context);
    if (creatorProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        creatorProvider.activeTeacher != null
            ? EditCreatorProfileButton(
                teacher: creatorProvider.activeTeacher!,
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppPaddings.large),
          child: Center(
            child: CreatorSwitchToUserModeButton(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppPaddings.medium,
          ),
          child: Text("Settings",
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        const SizedBox(height: AppPaddings.small),
        CreatorStripeConnectButton(creatorProvider: creatorProvider),
      ],
    );
  }
}
