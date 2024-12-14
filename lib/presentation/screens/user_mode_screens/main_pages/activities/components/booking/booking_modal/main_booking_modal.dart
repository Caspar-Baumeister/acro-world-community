import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/checkout_step.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/option_choosing.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/booking_step_indicator.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/header_section.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class BookingModal extends StatefulWidget {
  const BookingModal(
      {super.key, required this.classEvent, required this.refetch});

  final ClassEvent classEvent;
  final void Function()? refetch;

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  late String? currentOption;
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
              color: CustomColors.primaryColor,
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
            BookingStepIndicator(
              currentStep: step,
              setStep: (int newStep) {
                setState(() {
                  step = newStep;
                });
              },
            ),
            const SizedBox(height: 20.0),
            teacherStripeId == null
                ? const Text("This teacher is not yet connected to Stripe")
                : step == 0
                    ? OptionChoosingStep(
                        className: clas.name!,
                        classDate: widget.classEvent.startDateDT,
                        classBookingOptions: clas.classBookingOptions ?? [],
                        placesLeft: widget.classEvent.availableBookingSlots,
                        onOptionSelected: (p0) => setCurrentOption(p0),
                        currentOption: currentOption,
                        maxPlaces: widget.classEvent.maxBookingSlots,
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
                        questions: clas.questions,
                        classEventId: widget.classEvent.id,
                      ),
          ],
        ),
      ),
    );
  }
}
