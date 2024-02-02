import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/events/event_bus_provider.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/account_settings/edit_userdata.dart';
import 'package:acroworld/services/stripe_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// TODO create a stripe service that handles all stripe related stuff

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
                  print("pressed pay");
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
      await StripeService().attemptToPresentPaymentSheet().then((value) {
        Navigator.of(context).pop();
        // TODO refresh the booking status from stripe and then refresh the queries
        // Access the EventBusProvider
        var eventBusProvider =
            Provider.of<EventBusProvider>(context, listen: false);
// Fire the refetch event for booking query
        eventBusProvider.fireRefetchBookingQuery();
      });
    } on StripeException catch (e) {
      CustomErrorHandler.captureException(e, stackTrace: StackTrace.current);
    }
  }

  Future<void> initPaymentSheet(
      String bookingOptionId, String classEventId) async {
    try {
      User? user = Provider.of<UserProvider>(context, listen: false).activeUser;

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

      StripeService()
          .initPaymentSheet(user, bookingOptionId, classEventId)
          .then((value) {
        if (value) {
          return setState(() {
            _ready = true;
          });
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
                  "Error initializing payment, try again later or contact support",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } catch (e, stackTrace) {
      // show flutter toast with error
      Fluttertoast.showToast(
          msg: "Error initializing payment, try again later or contact support",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      CustomErrorHandler.captureException(e, stackTrace: stackTrace);
    }
  }
}
