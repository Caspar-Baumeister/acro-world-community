import 'package:acroworld/core/exceptions/error_handler.dart';
import 'package:acroworld/core/utils/colors.dart';
import 'package:acroworld/core/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/presentation/screens/account_settings_pages/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/shared_components/buttons/custom_button.dart';
import 'package:acroworld/services/stripe_service.dart';
import 'package:acroworld/state/events/event_bus_provider.dart';
import 'package:acroworld/state/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
  String? paymentIntentId;

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
                  color: CustomColors.secondaryBackgroundColor,
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
                              style: Theme.of(context).textTheme.titleLarge,
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
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            widget.bookingOption
                                    .realPriceDiscounted()
                                    .toStringAsFixed(2) +
                                widget.bookingOption.currency.symbol,
                            style: Theme.of(context).textTheme.bodySmall,
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
                  color: CustomColors.secondaryBackgroundColor,
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
                            "Your information",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            onPressed: () {
                              // route to EditUserdata
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditUserdataPage(),
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
                          Text(
                            "Name",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "${user.name}",
                            style: Theme.of(context).textTheme.bodySmall,
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
                          Text(
                            "Email",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            "${user.email}",
                            style: Theme.of(context).textTheme.bodySmall,
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
                          Text(
                            "Acro level",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            user.level?.name ?? "Not specified",
                            style: Theme.of(context).textTheme.bodySmall,
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
                          Text(
                            "Acro Role",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            user.gender?.name ?? "Not specified",
                            style: Theme.of(context).textTheme.bodySmall,
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
                "Continue to payment",
                () async {
                  if (paymentIntentId == null) {
                    showErrorToast(
                      "Something went wrong. Try again later or contact the support",
                    );
                  } else {
                    print("pressed pay");
                    await attemptToPresentPaymentSheet(paymentIntentId!);
                  }
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

  Future<void> attemptToPresentPaymentSheet(String paymentIntentId) async {
    try {
      await StripeService()
          .attemptToPresentPaymentSheet(paymentIntentId)
          .then((value) {
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
        showErrorToast(
          "Please redo the login process and try again",
        );
        Navigator.pop(context);
        return;
      }

      StripeService()
          .initPaymentSheet(user, widget.bookingOption, classEventId)
          .then((paymentIntent) {
        if (paymentIntent != null) {
          return setState(() {
            _ready = true;
            paymentIntentId = paymentIntent;
          });
        } else {
          Navigator.pop(context);
          showErrorToast(
            "Error initializing payment, try again later or contact support",
          );
        }
      });
    } catch (e, stackTrace) {
      // show flutter toast with error
      showErrorToast(
        "Error initializing payment, try again later or contact support",
      );

      CustomErrorHandler.captureException(e, stackTrace: stackTrace);
    }
  }
}
