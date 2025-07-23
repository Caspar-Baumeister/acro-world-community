// lib/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/booking_step_indicator.dart

import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_option_selection_provider.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_step_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A 2- or 3-step indicator that
/// - Disables the "Questionnaire" step if no option chosen
/// - Omits Questionnaire entirely if noQuestions==true
class CustomStepper extends ConsumerWidget {
  const CustomStepper({super.key, required this.hasQuestions});

  /// If true, show "Questionnaire" as a middle step.
  final bool hasQuestions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(bookingStepProvider);
    final selectedOption = ref.watch(selectedBookingOptionIdProvider);

    // Build dynamic labels:
    final labels = <String>["Choose option"];
    if (hasQuestions) labels.add("Questionnaire");
    labels.add("Checkout");

    // Map current step to index in labels:
    int currentIndex;
    switch (step) {
      case BookingStep.optionSelection:
        currentIndex = 0;
        break;
      case BookingStep.questionnaire:
        // If no questionnaire step, treat as checkout
        currentIndex = hasQuestions ? 1 : labels.length - 1;
        break;
      case BookingStep.summary:
        currentIndex = labels.length - 1;
        break;
    }

    void setStep(int index) {
      final notifier = ref.read(bookingStepProvider.notifier);

      if (index == 0) {
        notifier.state = BookingStep.optionSelection;
      } else if (hasQuestions && index == 1) {
        // Questionnaire step tapped
        if (selectedOption == null) {
          // don't allow advancing to questions if no option selected
          return;
        }
        notifier.state = BookingStep.questionnaire;
      } else if (index == labels.length - 1) {
        // Checkout tapped
        if (selectedOption == null) {
          // don't allow advancing to checkout if no option selected
          return;
        }
        notifier.state = BookingStep.summary;
      }
    }

    // Build the row of labels + arrows:
    final children = <Widget>[];
    for (var i = 0; i < labels.length; i++) {
      // Label
      children.add(
        GestureDetector(
          onTap: () => setStep(i),
          child: Text(
            labels[i],
            textAlign: TextAlign.center,
            style: i == currentIndex
                ? Theme.of(context).textTheme.titleSmall
                : Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: CustomColors.lightTextColor),
          ),
        ),
      );
      // Arrow (except after last)
      if (i < labels.length - 1) {
        children.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(Icons.arrow_forward_ios,
              size: 10, color: CustomColors.lightTextColor),
        ));
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width.clamp(0, 300),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
