import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/checkout_step.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/steps/option_choosing.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/booking_step_indicator.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/header_section.dart';
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
    if (widget.classEvent.classModel?.bookingOptions[0].id != null) {
      currentOption = widget.classEvent.classModel!.bookingOptions[0].id!;
    }
  }

  // set current option to the selected option
  void setCurrentOption(String value) {
    setState(() {
      currentOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ClassModel clas = widget.classEvent.classModel!;

    BookingOption? currentOptionObject;
    if (currentOption != null) {
      currentOptionObject =
          clas.bookingOptions.firstWhere((e) => e.id == currentOption);
    }

    String? teacherStripeId = clas.owner?.teacher?.stripeId;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          // Header section (fixed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BookingHeader(
              className: clas.name,
              teacherName: (clas.classTeachers != null &&
                      clas.classTeachers!.isNotEmpty &&
                      clas.classTeachers![0].teacher?.name != null)
                  ? clas.classTeachers![0].teacher!.name
                  : null,
              startDate: widget.classEvent.startDateDT,
              endDate: widget.classEvent.endDateDT,
              currentStep: step,
            ),
          ),
          const SizedBox(height: 20.0),
          // Step indicator (fixed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BookingStepIndicator(
              currentStep: step,
              setStep: (int newStep) {
                setState(() {
                  step = newStep;
                });
              },
            ),
          ),
          const SizedBox(height: 20.0),
          // Content area (flexible/scrollable)
          Expanded(
            child: step == 0
                ? OptionChoosingStep(
                    classEventId: widget.classEvent.id!,
                    className: clas.name!,
                    classDate: widget.classEvent.startDateDT,
                    bookingCategories: clas.bookingCategories ?? [],
                    placesLeft: widget.classEvent.availableBookingSlots,
                    onOptionSelected: (p0) => setCurrentOption(p0),
                    currentOption: currentOption,
                    maxPlaces: widget.classEvent.maxBookingSlots,
                    nextStep: () async {
                      setState(() {
                        step = 1;
                      });
                    },
                  )
                : CheckoutStep(
                    className: clas.name!,
                    classDate: widget.classEvent.startDateDT,
                    bookingOption: currentOptionObject!,
                    previousStep: () {
                      setState(() {
                        step = 0;
                      });
                    },
                    questions: clas.questions,
                    classEventId: widget.classEvent.id,
                    isDirectPayment:
                        teacherStripeId != null && teacherStripeId.isNotEmpty,
                    isCashPayment: clas.isCashAllowed ?? false,
                  ),
          ),
        ],
      ),
    );
  }
}
