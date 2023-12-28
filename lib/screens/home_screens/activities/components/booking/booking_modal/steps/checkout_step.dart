import 'dart:convert';

import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/account_settings/edit_userdata.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CheckoutStep extends StatefulWidget {
  const CheckoutStep(
      {super.key,
      required this.className,
      required this.classDate,
      required this.bookingOption,
      required this.previousStep,
      required this.teacherStripeId,
      this.classEventId});

  final String className;
  final DateTime classDate;
  final String teacherStripeId;
  final BookingOption bookingOption;
  final Function previousStep;
  final String? classEventId;

  @override
  State<CheckoutStep> createState() => _CheckoutStepState();
}

class _CheckoutStepState extends State<CheckoutStep> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if (widget.bookingOption.id != null && widget.classEventId != null) {
      initPaymentSheet(widget.bookingOption.id!, widget.classEventId!);
    } else {
      CustomErrorHandler.captureException(
          Exception(
              "Booking option id or class event id is null when trying to book a class"),
          stackTrace: StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).activeUser!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Container(
                // round corners and add shadow
                decoration: BoxDecoration(
                  color: SLIGHTEST_GREY_BG,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // an edit icon in the top right corner
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title of the booking summary
                          Flexible(
                            child: Text(
                              "Booking summary for ${widget.className}",
                              style: H16W7,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              widget.previousStep();
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.bookingOption.title}",
                            style: H12W4,
                          ),
                          Text(
                            "${widget.bookingOption.price}€",
                            style: H12W4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // the same container with information about the user (name, email)
              Container(
                // round corners and add shadow
                decoration: BoxDecoration(
                  color: SLIGHTEST_GREY_BG,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // an edit icon in the top right corner
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title of the booking summary
                          const Text(
                            "Your information",
                            style: H16W7,
                          ),
                          IconButton(
                            onPressed: () {
                              // route to EditUserdata
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditUserdata(),
                                  // EditUserdata(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Name",
                            style: H12W4,
                          ),
                          Text(
                            "${user.name}",
                            style: H12W4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Email",
                            style: H12W4,
                          ),
                          Text(
                            "${user.email}",
                            style: H12W4,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Acro level",
                            style: H12W4,
                          ),
                          Text(
                            user.level?.name ?? "Not specified",
                            style: H12W4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Acro Role",
                            style: H12W4,
                          ),
                          Text(
                            user.gender?.name ?? "Not specified",
                            style: H12W4,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              CustomButton(
                "Pay",
                () async {
                  await attemptToPresentPaymentSheet();
                },
                loading: !_ready,
                width: double.infinity,
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> attemptToPresentPaymentSheet() async {
    try {
      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      CustomErrorHandler.captureException(e, stackTrace: StackTrace.current);
    }
  }

  Future<void> initPaymentSheet(
      String bookingOptionId, String classEventId) async {
    try {
      User? user = Provider.of<UserProvider>(context, listen: false).activeUser;

      // TODO if user is null, tell the user that login is required then close the booking modal
      // for now we assume that if the user is not logged in, there is an error
      if (user == null || user.id == null) {
        Fluttertoast.showToast(
            msg: "Please redo the login process and try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
        return;
      }

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
          paymentIntentClientSecret:
              paymentSheetResponseData!['payment_intent'],
          // Customer keys
          customerEphemeralKeySecret: paymentSheetResponseData['ephemeral_key'],
          customerId: paymentSheetResponseData['customer_id'],
          // Extra options
          style: ThemeMode.dark,
          billingDetails: billingDetails,
          // appearance:  PaymentSheetAppearance
          // (
          //   colors: PaymentSheetAppearanceColors
          // (
          //     background: Colors.white,
          //     secondaryText: Colors.grey,
          //     error: Colors.red,
          //     primaryText: Colors.black),
          //   ),
        ),
      );
      print("Response from payment sheet: ${response.toString()}");
      setState(() {
        _ready = true;
      });
    } catch (e, stackTrace) {
      // show flutter toast with error
      Fluttertoast.showToast(
          msg: "Error initializing payment sheet: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      CustomErrorHandler.captureException(e, stackTrace: stackTrace);
    }
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

  Future<Map<String, dynamic>> createTestPaymentSheet(
      String? userId,
      num? amount,
      String currency,
      String destinationAcct,
      String classEventId,
      String bookingOptionId) async {
    // get User id
    if (userId == null) {
      throw Exception("User id is null");
    }

    // TODO define real host
    // if platform is android, use 10.0.2.2 instead of localhost
    String host = "http://localhost:3000"; // "10.0.2.2"; //
    // if (Theme.of(context).platform == TargetPlatform.android) {
    //   host = "10.0.2.2";
    // }
    // 1. create payment intent on the server (localhost for now)
    final url = Uri.parse('$host/stripe/create-payment-sheet');
    // 2. create a body with {"amount" : 300, "destination": "acct_1O5td34FPJL5TYTc", "currency": "eur", "application_fee_amount": 10}
    if (amount == null) {
      throw Exception("Amount is null");
    }
    final body = jsonEncode({
      "amount": amount * 100,
      "destination": destinationAcct,
      "currency": currency,
      "user_id": userId,
      "class_event_id": classEventId,
      "booking_option_id": bookingOptionId
    });
    // 3. make a post request to the url with the body
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);
    // print the response with title
    print("Response from server: ${response.body}");

    return jsonDecode(response.body);
  }
}
