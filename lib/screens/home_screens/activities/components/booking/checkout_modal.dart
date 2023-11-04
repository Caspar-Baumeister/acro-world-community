import 'dart:convert';

import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// makes an test payment with stripe to the account acct_1O5td34FPJL5TYTc

class CheckoutModal extends StatefulWidget {
  const CheckoutModal(
      {Key? key, required this.classEvent, required this.bookingOption})
      : super(key: key);

  // get the selected class event and the selected booking option
  final ClassEvent classEvent;
  final BookingOption bookingOption;

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    initPaymentSheet();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 24.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: PRIMARY_COLOR,
              thickness: 5.0,
              indent: width * 0.40,
              endIndent: width * 0.40,
            ),
            const SizedBox(height: 12.0),
            const Text(
              "Checkout",
              style: H16W7,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            // a column of 3 random booking options
            Column(
              children: [
                // show the user the class event information
                Text(
                  "Class: ${widget.classEvent.classModel!.name}",
                  style: H16W7,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Date: ${DateFormat('EEEE, H:mm').format(widget.classEvent.date)}",
                  style: H16W7,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                // a row with the booking option name and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Booking option: ${widget.bookingOption.title}",
                      style: H16W7,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      "Price: ${widget.bookingOption.price}€",
                      style: H16W7,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                // a cutsombutton that opens the stripe payment modal
                CustomButton(
                  "Pay now",
                  () async {
                    await Stripe.instance.presentPaymentSheet();
                  },
                  loading: !_ready,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await _createTestPaymentSheet();

      // define some billing details
      const billingDetails = BillingDetails(
        email: "ca@as.de",
        phone: "+49123456789",
        address: Address(
          city: "Berlin",
          country: "DE",
          line1: "Test street 1",
          line2: "Test street 2",
          postalCode: "12345",
          state: "Berlin",
        ),
      );

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

  Future<Map<String, dynamic>> _createTestPaymentSheet() async {
    // get User id
    String? userId =
        Provider.of<UserProvider>(context, listen: false).activeUser?.id;
    if (userId == null) {
      throw Exception("User id is null");
    }
    // if platform is android, use 10.0.2.2 instead of localhost
    String host = "localhost"; // "10.0.2.2"; //
    // if (Theme.of(context).platform == TargetPlatform.android) {
    //   host = "10.0.2.2";
    // }
    // 1. create payment intent on the server (localhost for now)
    final url = Uri.parse('http://$host:3000/stripe/create-payment-sheet');
    // 2. create a body with {"amount" : 300, "destination": "acct_1O5td34FPJL5TYTc", "currency": "eur", "application_fee_amount": 10}
    final body = jsonEncode({
      "amount": 300,
      "destination": "acct_1O5td34FPJL5TYTc",
      "currency": "eur",
      "application_fee_amount": 10,
      "user_id": userId
    });
    // 3. make a post request to the url with the body
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);
    // print the response with title
    print("Response from server: ${response.body}");

    return jsonDecode(response.body);
  }
}
