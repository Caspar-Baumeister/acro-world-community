// Stripe Service class for making bookings

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StripeService {
  Future<String?> initPaymentSheet(
      User user, String bookingOptionId, String classEventId) async {
    // 1. create payment intent on the server
    final paymentSheetResponseData = await _createPaymentSheet(
      bookingOptionId,
      classEventId,
    );

    // define some billing details
    var billingDetails = BillingDetails(
      email: user.email,
      name: user.name,
      phone: "+49123456789",
      address: const Address(
        city: "Berlin",
        country: "Germany",
        line1: "Karl-Marx-Str. 1",
        line2: "Karl-Marx-Str. 2",
        postalCode: "12043",
        state: "Berlin",
      ),
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

    final response = await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Set to true for custom flow
        customFlow: false,
        // Main params
        merchantDisplayName: "AcroWorld",
        paymentIntentClientSecret: paymentSheetResponseData['payment_intent'],
        // Customer keys
        customerEphemeralKeySecret: paymentSheetResponseData['ephemeral_key'],
        customerId: paymentSheetResponseData['customer_id'],
        // Extra options
        style: ThemeMode.dark,
        billingDetails: billingDetails,
      ),
    );
    print("Response from payment sheet: ${response.toString()}");

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
      GraphQLClientSingleton().mutate(options);
    } catch (e) {
      CustomErrorHandler.captureException(e);
    }
    print("present: $present");
  }

  Future<Map<String, dynamic>?> _createPaymentSheet(
      String bookingOptionId, String classEventId) async {
    {
      QueryResult<Object?> response = await GraphQLClientSingleton().mutate(
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
