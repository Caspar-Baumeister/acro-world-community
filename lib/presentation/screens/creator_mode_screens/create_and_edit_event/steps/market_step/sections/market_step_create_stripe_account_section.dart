import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:acroworld/theme/app_dimensions.dart';

class MarketStepCreateStripeAccountSection extends StatelessWidget {
  const MarketStepCreateStripeAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    // CreatorProvider creatorProvider = Provider.of<CreatorProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingLarge),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        padding: const EdgeInsets.all(AppDimensions.spacingMedium),
        child: Column(
          children: [
            // Text explaining the need to create a Stripe account with a link to open info dialog explaing fees
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
              child: RichText(
                  text: TextSpan(
                text:
                    'To accept direct payments for your events, you need to create a Stripe account. To learn more about the fees, ',
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Click here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Open info dialog or link
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Acroworld Stripe Fees'),
                            // This is a RichText widget to display the fees information and link to stripe website
                            content: RichText(
                              text: TextSpan(
                                  text:
                                      'Acroworld charges a 2% fee on each transaction. This fee is deducted from the total amount paid by the customer. The payment processor (Stripe) also charges a fee depending on the selected payment method. For more details, ',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                  children: [
                                    TextSpan(
                                      text: 'visit Stripe',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Open Stripe website
                                          launchUrl(Uri.parse(
                                              'https://stripe.com/en-de/pricing/local-payment-methods'));
                                        },
                                    ),
                                  ]),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                  ),
                  TextSpan(
                      text:
                          "\n\nAfter saving your event, you can connect to stripe in your profile. Afterwards, you can edit your event to add tickets and accept direct payments."),
                ],
              )),
            ),
            // const SizedBox(height: AppDimensions.spacingMedium),
            // CreatorStripeConnectButton(creatorProvider: creatorProvider),
          ],
        ),
      ),
    );
  }
}
