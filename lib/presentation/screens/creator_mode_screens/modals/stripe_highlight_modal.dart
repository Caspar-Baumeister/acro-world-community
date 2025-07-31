import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

// This modal will be shown after the user creates a new class (when the user selcted an event to be highlighted)
// or when the user clicks on the highlight your event button
class StripeHighlightModal extends StatelessWidget {
  const StripeHighlightModal(
      {super.key, required this.classEventId, required this.startDate});

  final String classEventId;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    return BaseModal(
        child: Column(
      children: [
        Text('Highlight your event and increase your visibility',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center),
        SizedBox(height: AppDimensions.spacingMedium),
        Text(
            "Your event will be shown at the top of the global event list until the event starts",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: AppDimensions.spacingMedium),
        // Query that shows the price and explains what it cost per day
        HighlightPriceQuery(startDate: startDate, classEventId: classEventId),
      ],
    ));
  }
}

class BuyHighlightStripeButton extends StatelessWidget {
  const BuyHighlightStripeButton({
    super.key,
    required this.classEventId,
    required this.price,
  });

  final String classEventId;
  final double price;

  @override
  Widget build(BuildContext context) {
    return StandartButton(
        text: "Buy Highlight",
        onPressed: () {
          initPaymentSheet(context, classEventId, price);
        });
  }

  Future<void> initPaymentSheet(
      BuildContext context, String classEventId, double amount) async {
    try {
      final stripeRepository =
          StripeRepository(apiService: GraphQLClientSingleton());
      // 1. create payment intent on the server and ?update event highlight?
      final data = await stripeRepository.createDirectChargePaymentSheet(
          classEventId, amount);

      if (data == null) {
        throw Exception('Failed to create payment sheet in backend server');
      }

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['payment_intent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeral_key'],
          customerId: data['customer_id'],
          // Extra options
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
        ),
      );

      // 3. present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. confirm the payment intent
      await stripeRepository.confirmPayment(
        data['payment_intent'],
      );

      // 5. Fire the refetch event for booking query
      print("Fire refetch event for booking query");
      var eventBusProvider =
          Provider.of<EventBusProvider>(context, listen: false);
      // Fire the refetch event for booking query
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      showSuccessToast("Payment successful");
      eventBusProvider.fireRefetchEventHighlightsQuery();
    } catch (e) {
      showErrorToast("Failed to initialize payment. Please contact support");
      rethrow;
    }
  }
}

class HighlightPriceQuery extends StatelessWidget {
  const HighlightPriceQuery({
    super.key,
    required this.startDate,
    required this.classEventId,
  });

  final DateTime startDate;
  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: Queries.config,
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException ||
              result.data == null ||
              result.data!['config']?[0]?['daily_highlight_commission'] ==
                  null) {
            return Text(
                'Currently not available, contact support for highlight',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.error));
          }

          if (result.isLoading) {
            return Text('loading...',
                style: Theme.of(context).textTheme.bodyMedium);
          }

          final int pricePerDay =
              result.data!['config'][0]['daily_highlight_commission'];
          final double price = (pricePerDay.toDouble() *
                  startDate.difference(DateTime.now()).inDays) -
              2;

          return Column(
            children: [
              Text('Total price: ${(price / 100).toStringAsFixed(2)}€',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                  'Price per day: ${(pricePerDay.toDouble() / 100).toStringAsFixed(2)}€',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: AppDimensions.spacingMedium),
              BuyHighlightStripeButton(
                  classEventId: classEventId, price: price),
            ],
          );
        });
  }
}
