import 'dart:convert';

import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/account_settings/edit_userdata.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CheckoutStep extends StatefulWidget {
  const CheckoutStep(
      {Key? key,
      required this.className,
      required this.classDate,
      required this.bookingOption,
      required this.previousStep,
      required this.teacherStripeId,
      this.classEventId})
      : super(key: key);

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
  @override
  void initState() {
    super.initState();
    initPaymentSheet(widget.bookingOption);
  }

  bool _ready = false;
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
                          Text(
                            "Booking summary for ${widget.className}",
                            style: H16W7,
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
                "Pay now",
                () async {
                  await Stripe.instance.presentPaymentSheet();
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

  Future<void> initPaymentSheet(BookingOption bookingOption) async {
    try {
      User user = Provider.of<UserProvider>(context, listen: false).activeUser!;

      // if user id, booking option id or class event id is null, throw an exception
      if (user.id == null ||
          bookingOption.id == null ||
          widget.classEventId == null) {
        throw Exception("User id, booking option id or class event id is null");
      }

      // 1. create payment intent on the server
      final data = await _createTestPaymentSheet(
          user.id,
          bookingOption.price,
          bookingOption.currency,
          widget.teacherStripeId,
          widget.classEventId!,
          bookingOption.id!);

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
              state: "Berlin"));

      // 2. initialize the payment sheet
      final response = await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['paymentIntent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
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
    } catch (e) {
      // show flutter toast with error
      Fluttertoast.showToast(
          msg: "Error initializing payment sheet: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      rethrow;
    }
  }

  Future<Map<String, dynamic>> _createTestPaymentSheet(
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
