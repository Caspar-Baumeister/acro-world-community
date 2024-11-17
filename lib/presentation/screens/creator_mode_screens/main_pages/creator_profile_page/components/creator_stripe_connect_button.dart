import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class CreatorStripeConnectButton extends StatelessWidget {
  const CreatorStripeConnectButton({
    super.key,
    required this.creatorProvider,
  });

  final CreatorProvider creatorProvider;

  @override
  Widget build(BuildContext context) {
    return CustomSettingComponent(
      title: "Payment",
      content: creatorProvider.activeTeacher?.stripeId != null
          ? creatorProvider.activeTeacher?.isStripeEnabled == true
              ? "View Stripe dashboard"
              : "Continue Stripe setup"
          : "Connect to Stripe",
      onPressed: () async {
        print("Stripe connect button pressed");
        print("Stripe id: ${creatorProvider.activeTeacher?.stripeId}");
        print(
            "Stripe enabled: ${creatorProvider.activeTeacher?.isStripeEnabled}");
        if (creatorProvider.activeTeacher?.stripeId != null &&
            creatorProvider.activeTeacher?.isStripeEnabled != true) {
          // stripe id is set but not enabled
          await creatorProvider.createStripeUser().then((value) {
            if (value != null) {
              // open stripe dashboard
              customLaunch(value);
            } else {
              showErrorToast("Failed to open stripe dashboard");
            }
          });
          // stripe id is set and enabled
        } else if (creatorProvider.activeTeacher?.isStripeEnabled == true &&
            creatorProvider.activeTeacher?.stripeId != null) {
          // open stripe dashboard
          await creatorProvider.getStripeLoginLink().then((value) {
            if (value != null) {
              // open stripe dashboard
              customLaunch(value);
            } else {
              // refresh Stripe status
              // TODO: refresh stripe status
              // TODO: take the link from before and open it
              showErrorToast("not implemented yet");
            }
          });
        } else {
          // connect to stripe
          await creatorProvider.createStripeUser().then((value) {
            if (value != null) {
              // open stripe dashboard
              customLaunch(value);
            } else {
              showErrorToast("Failed to open stripe dashboard");
            }
          });
        }
      },
    );
  }
}
