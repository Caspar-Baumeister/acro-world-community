// Stripe Service class for making bookings

import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StripeService {
  Future<String?> initPaymentSheet(
      User user, BookingOption bookingOption, String classEventId) async {
    // 1. create payment intent on the server
    final paymentSheetResponseData = await _createPaymentSheet(
      bookingOption.id!,
      classEventId,
    );

    var billingDetails = BillingDetails(
      email: user.email,
      name: user.name,
    );

    print("Payment sheet response data: $paymentSheetResponseData");
    if (paymentSheetResponseData == null ||
        paymentSheetResponseData["payment_intent"] == null) {
      CustomErrorHandler.captureException(
          Exception(
              "Payment sheet response data is null + ${paymentSheetResponseData?["payment_intent"]}"),
          stackTrace: StackTrace.current);

      return null;
    }
    // 2. initialize the payment sheet
    var amount = '${bookingOption.price! / 100}';
    try {
      final response = await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            // Set to true for custom flow
            customFlow: false,
            // Main params
            merchantDisplayName: "AcroWorld",
            paymentIntentClientSecret:
                paymentSheetResponseData['payment_intent'],
            // Customer keys
            customerEphemeralKeySecret:
                paymentSheetResponseData['ephemeral_key'],
            customerId: paymentSheetResponseData['customer_id'],
            // Extra options
            style: ThemeMode.dark,
            billingDetails: billingDetails,
            allowsDelayedPaymentMethods: true,
            googlePay: PaymentSheetGooglePay(
              merchantCountryCode: "DE",
              label: bookingOption.title,
              currencyCode: bookingOption.currency.label,
              amount: amount,
              testEnv: !AppEnvironment.isProdBuild,
            ),
            applePay:
                PaymentSheetApplePay(merchantCountryCode: "DE", cartItems: [
              ImmediateCartSummaryItem(
                label: bookingOption.title!,
                amount: amount,
              )
            ])),
      );
      print("Response from payment sheet: ${response.toString()}");
    } catch (e, stacktrace) {
      CustomErrorHandler.captureException(e, stackTrace: stacktrace);
    }

    return paymentSheetResponseData['payment_intent'];
  }

  Future<void> attemptToPresentPaymentSheet(String paymentIntentId) async {
    PaymentSheetPaymentOption? present =
        await Stripe.instance.presentPaymentSheet();

    MutationOptions options = MutationOptions(
      document: Mutations.confirmPayment,
      variables: {'payment_intent_id': paymentIntentId},
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;

      await graphQLClient.mutate(options);
    } catch (e) {
      CustomErrorHandler.captureException(e);
    }
    print("present: $present");
  }

  Future<Map<String, dynamic>?> _createPaymentSheet(
      String bookingOptionId, String classEventId) async {
    {
      final graphQLClient = GraphQLClientSingleton().client;

      QueryResult<Object?> response = await graphQLClient.mutate(
          MutationOptions(
              fetchPolicy: FetchPolicy.networkOnly,
              document: Mutations.createPaymentSheet,
              variables: {
            "bookingOptionId": bookingOptionId,
            "classEventId": classEventId,
          }));
      if (response.hasException) {
        CustomErrorHandler.captureException(response.exception,
            stackTrace: response.exception!.originalStackTrace);
      } else if (response.data != null) {
        print("Response from server: ${response.data}");
        return response.data!["create_payment_sheet"];
      }
      print("response: $response");
      print("Something went wrong while creating payment sheet.");
      return null;
    }
  }
}
