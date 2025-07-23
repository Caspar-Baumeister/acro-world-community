import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for steps in the booking flow
enum BookingStep {
  optionSelection,
  questionnaire,
  summary,
}

/// Holds the current step in the booking flow.
final bookingStepProvider = StateProvider<BookingStep>((ref) {
  return BookingStep.optionSelection; // default starting point
});

/// Helper to go to the next step (skips questionnaire if needed)
void goToNextBookingStep(WidgetRef ref, {required bool hasQuestions}) {
  final current = ref.read(bookingStepProvider);

  switch (current) {
    case BookingStep.optionSelection:
      if (hasQuestions) {
        ref.read(bookingStepProvider.notifier).state =
            BookingStep.questionnaire;
      } else {
        ref.read(bookingStepProvider.notifier).state = BookingStep.summary;
      }
      break;
    case BookingStep.questionnaire:
      ref.read(bookingStepProvider.notifier).state = BookingStep.summary;
      break;
    case BookingStep.summary:
      // Stay or redirect to confirmation outside of stepper
      break;
  }
}

/// Helper to go back to the previous step
void goToPreviousBookingStep(WidgetRef ref, {required bool hasQuestions}) {
  final current = ref.read(bookingStepProvider);

  switch (current) {
    case BookingStep.summary:
      if (hasQuestions) {
        ref.read(bookingStepProvider.notifier).state =
            BookingStep.questionnaire;
      } else {
        ref.read(bookingStepProvider.notifier).state =
            BookingStep.optionSelection;
      }
      break;
    case BookingStep.questionnaire:
      ref.read(bookingStepProvider.notifier).state =
          BookingStep.optionSelection;
      break;
    case BookingStep.optionSelection:
      // stay or pop from navigation
      break;
  }
}
