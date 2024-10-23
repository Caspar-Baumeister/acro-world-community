import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class MarketStepCreateStripeAccountSection extends StatelessWidget {
  const MarketStepCreateStripeAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddings.medium),
        child: Column(
          children: [
            Text(
              "To directly sell tickets in the app, you need to connect a Stripe account.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppPaddings.medium),
            StandardButton(
              onPressed: () {},
              text: 'Connect Stripe Account',
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
