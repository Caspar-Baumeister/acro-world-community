import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/creator_stripe_connect_button.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketStepCreateStripeAccountSection extends StatelessWidget {
  const MarketStepCreateStripeAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    CreatorProvider creatorProvider = Provider.of<CreatorProvider>(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddings.medium),
        child: Column(
          children: [
            Text(
              "To directly sell tickets in the app, create or connect a Stripe account.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppPaddings.medium),
            CreatorStripeConnectButton(creatorProvider: creatorProvider),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
