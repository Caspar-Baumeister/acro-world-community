// Stripe Service class for making bookings

import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/data/repositories/stripe_repository.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final StripeRepository stripeRepository;

  StripeService({required this.stripeRepository});

  /// Initialize the payment sheet and configure parameters.
  /// [user] is the customer data, and [bookingOption] provides product details.
  Future<String?> initPaymentSheet(
      User user, BookingOption bookingOption, String classEventId) async {
    try {
      final paymentSheetResponseData =
          await stripeRepository.createPaymentSheet(
        bookingOption.id!,
        classEventId,
      );

      if (paymentSheetResponseData == null ||
          paymentSheetResponseData["payment_intent"] == null) {
        CustomErrorHandler.captureException(
            Exception(
                "Payment sheet response data is null + ${paymentSheetResponseData?["payment_intent"]}"),
            stackTrace: StackTrace.current);

        return null;
      }

      final billingDetails = BillingDetails(
        email: user.email,
        name: user.name,
      );

      // Configuring the payment sheet using response data and Stripe documentation parameters.
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          returnURL: 'flutterstripe://redirect',
          merchantDisplayName: "AcroWorld",
          paymentIntentClientSecret: paymentSheetResponseData['payment_intent'],
          customerEphemeralKeySecret: paymentSheetResponseData['ephemeral_key'],
          customerId: paymentSheetResponseData['customer_id'],
          style: ThemeMode.dark,
          billingDetails: billingDetails,
          allowsDelayedPaymentMethods: true,
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: "DE",
            label: bookingOption.title,
            currencyCode: bookingOption.currency.label,
            amount: '${bookingOption.price! / 100}',
            testEnv: !AppEnvironment.isProdBuild,
          ),
          applePay: PaymentSheetApplePay(
            merchantCountryCode: "DE",
            cartItems: [
              ImmediateCartSummaryItem(
                label: bookingOption.title!,
                amount: '${bookingOption.price! / 100}',
              )
            ],
          ),
        ),
      );
      return paymentSheetResponseData['payment_intent'];
    } catch (e, stacktrace) {
      CustomErrorHandler.captureException(e, stackTrace: stacktrace);
    }
    return null;
  }

  /// Present the payment sheet to complete the payment process.
  Future<void> attemptToPresentPaymentSheet(String paymentIntentId) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await stripeRepository.confirmPayment(paymentIntentId);
    } catch (e) {
      CustomErrorHandler.captureException(e);
    }
  }
}
