// Stripe Service class for making bookings

import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StripeService {
  Future<void> initPaymentSheet(
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
    if (paymentSheetResponseData == null) {
      CustomErrorHandler.captureException(
          Exception("Payment sheet response data is null"),
          stackTrace: StackTrace.current);
    }
    // 2. initialize the payment sheet

    final response = await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Set to true for custom flow
        customFlow: false,
        // Main params
        merchantDisplayName: "AcroWorld",
        paymentIntentClientSecret: paymentSheetResponseData!['payment_intent'],
        // Customer keys
        customerEphemeralKeySecret: paymentSheetResponseData['ephemeral_key'],
        customerId: paymentSheetResponseData['customer_id'],
        // Extra options
        style: ThemeMode.dark,
        billingDetails: billingDetails,
      ),
    );
    print("Response from payment sheet: ${response.toString()}");
  }

  Future<void> attemptToPresentPaymentSheet() async {
    PaymentSheetPaymentOption? present =
        await Stripe.instance.presentPaymentSheet();
    print("present: $present");
  }

  Future<Map<String, dynamic>?> _createPaymentSheet(
      String bookingOptionId, String classEventId) async {
    {
      QueryResult<Object?> response = await GraphQLClientSingleton().mutate(
          MutationOptions(document: Mutations.createPaymentSheet, variables: {
        "bookingOptionId": bookingOptionId,
        "classEventId": classEventId,
      }));
      if (response.hasException) {
        CustomErrorHandler.captureException(response.exception,
            stackTrace: response.exception!.originalStackTrace);
      } else if (response.data != null) {
        return response.data!["create_payment_sheet"];
      }
      print("Response from server: ${response.data}");
      return null;
    }
  }
}
