import 'dart:convert';

import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// makes an test payment with stripe to the account acct_1O5td34FPJL5TYTc

class StripeTestModal extends StatefulWidget {
  const StripeTestModal({super.key});

  @override
  State<StripeTestModal> createState() => _StripeTestModalState();
}

class _StripeTestModalState extends State<StripeTestModal> {
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
              "Stripe test",
              style: H16W7,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            // a column of 3 random booking options
            Column(
              children: [
                BookingOptionWidget(
                  bookingOption: DummyBookingOption(
                      amount: 1,
                      currency: "€",
                      price: 10.0,
                      name: "Test option 1",
                      description: "Test option 1 description",
                      id: "1"),
                  onChanged: (bool value) {},
                  selected: false,
                ),
                BookingOptionWidget(
                  bookingOption: DummyBookingOption(
                      amount: 1,
                      currency: "€",
                      price: 20.0,
                      name: "Test option 2",
                      description: "Test option 2 description",
                      id: "2"),
                  onChanged: (bool value) {},
                  selected: false,
                ),
                BookingOptionWidget(
                  bookingOption: DummyBookingOption(
                      amount: 1,
                      currency: "€",
                      price: 30.0,
                      name: "Test option 3",
                      description: "Test option 3 description",
                      id: "3"),
                  onChanged: (bool value) {},
                  selected: false,
                ),

                // a cutsombutton that opens the stripe payment modal
                const SizedBox(height: 20.0),
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

// a widget that shows a booking option with a checkbox
class BookingOptionWidget extends StatelessWidget {
  const BookingOptionWidget(
      {required this.bookingOption,
      required this.onChanged,
      required this.selected,
      super.key});
  final DummyBookingOption bookingOption;
  final Function(bool) onChanged;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: selected,
      onChanged: (bool? value) => onChanged(value ?? false),
      title: Text(
        bookingOption.name,
        style: H12W4,
      ),
      subtitle: Text(
        bookingOption.description,
        style: H10W4,
      ),
      secondary: Text(
        "${bookingOption.price.toStringAsFixed(2)}${bookingOption.currency}",
        style: H12W4,
      ),
    );
  }
}

// a booking option class with amount, currency, price, name, description, id
class DummyBookingOption {
  DummyBookingOption(
      {required this.amount,
      required this.currency,
      required this.price,
      required this.name,
      required this.description,
      required this.id});

  factory DummyBookingOption.fromJson(Map<String, dynamic> json) {
    return DummyBookingOption(
        amount: json["amount"],
        currency: json["currency"],
        price: json["price"],
        name: json["name"],
        description: json["description"],
        id: json["id"]);
  }

  final int amount;
  final String currency;
  final double price;
  final String name;
  final String description;
  final String id;

  double deposit() {
    return price * 0.2;
  }

  double toPayOnArrival() {
    return price - deposit();
  }
}
