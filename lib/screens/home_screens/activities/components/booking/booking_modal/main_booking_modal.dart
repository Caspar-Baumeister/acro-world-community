import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_modal/steps/checkout_step.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_modal/steps/option_choosing.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingModal extends StatefulWidget {
  const BookingModal(
      {super.key,
      required this.classEvent,
      required this.placesLeft,
      required this.refetch});

  final ClassEvent classEvent;
  final num placesLeft;
  final void Function()? refetch;

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  late String? currentOption;
  bool loading = false;
  int step = 0;

  @override
  void initState() {
    super.initState();
    currentOption =
        widget.classEvent.classModel?.classBookingOptions?[0].bookingOption?.id;
  }

  // set current option to the selected option
  void setCurrentOption(String value) {
    setState(() {
      currentOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width;
    ClassModel clas = widget.classEvent.classModel!;

    BookingOption? currentOptionObject;
    if (currentOption != null) {
      currentOptionObject = clas.classBookingOptions!
          .firstWhere((e) => e.bookingOption?.id == currentOption)
          .bookingOption!;
    }

    String? teacherStripeId = clas.owner?.teacher?.stripeId;

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
            BookingHeader(
              className: clas.name!,
              teacherName: clas.classTeachers![0].teacher!.name!,
              startDate: widget.classEvent.startDateDT,
              endDate: widget.classEvent.endDateDT,
              currentStep: step,
            ),
            const SizedBox(height: 20.0),
            BookingStepIndicator(currentStep: step),
            const SizedBox(height: 20.0),
            teacherStripeId == null
                ? const Text("This teacher is not yet connected to Stripe")
                : step == 0
                    ? OptionChoosingStep(
                        className: clas.name!,
                        classDate: widget.classEvent.startDateDT,
                        classBookingOptions: clas.classBookingOptions ?? [],
                        placesLeft: widget.placesLeft.toInt(),
                        onOptionSelected: setCurrentOption,
                        currentOption: currentOption,
                        nextStep: () {
                          setState(() {
                            step = 1;
                          });
                        },
                      )
                    : CheckoutStep(
                        className: clas.name!,
                        classDate: widget.classEvent.startDateDT,
                        bookingOption: currentOptionObject!,
                        teacherStripeId: teacherStripeId,
                        previousStep: () {
                          setState(() {
                            step = 0;
                          });
                        },
                        classEventId: widget.classEvent.id,
                      ),
          ],
        ),
      ),
    );
  }
}

// a widget, that shows the user where he is in the booking process
class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({super.key, required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      // cap the width to 300
      width: MediaQuery.of(context).size.width > 300
          ? 300
          : MediaQuery.of(context).size.width,
      // round corners
      decoration: BoxDecoration(
        color: SLIGHTEST_GREY_BG,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // the first step
            Text(
              "Choose option",
              // the style indicates which step is the current one
              style: currentStep == 0
                  ? H12W8
                  : H12W4.copyWith(color: SLIGHTEST_GREY_TEXT),

              textAlign: TextAlign.center,
            ),
            // an arrow
            const Icon(
              Icons.arrow_forward_ios,
              color: SLIGHTEST_GREY_TEXT,
              size: 10,
            ),

            // the second step
            Text(
              "Checkout",
              // the style indicates which step is the current one
              style: currentStep == 1
                  ? H12W8
                  : H12W4.copyWith(color: SLIGHTEST_GREY_TEXT),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BookingHeader extends StatelessWidget {
  const BookingHeader(
      {super.key,
      required this.className,
      required this.teacherName,
      required this.startDate,
      required this.currentStep,
      required this.endDate});
  // classname
  final String className;
  final String teacherName;
  final DateTime startDate;
  final DateTime endDate;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // the class name in the header
        Text(
          className,
          style: H24W8,
          textAlign: TextAlign.center,
        ),
        // the teacher name
        const SizedBox(height: 8.0),
        Text(
          teacherName,
          style: H16W3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6.0),
        // the date in the form of "Monday 14.07.24, 12:00 am - 02:00 pm gmt"
        Text(
          "${DateFormat('EEEE dd.MM.yy, hh:mm a').format(startDate)} - ${DateFormat('hh:mm a').format(endDate)}",
          style: H16W3,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
