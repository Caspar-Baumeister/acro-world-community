import 'dart:io' show Platform;

import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/components/custom_stepper.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/pages/checkout_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/pages/option_selection_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/pages/questionnaire_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_step_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingFlow extends ConsumerWidget {
  const BookingFlow(this.event, {super.key});

  final ClassEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(bookingStepProvider);

    Widget page;
    switch (currentStep) {
      case BookingStep.optionSelection:
        page = OptionSelectionPage(
          classEvent: event,
        );
        break;
      case BookingStep.questionnaire:
        page = QuestionnairePage(classEvent: event);
        break;
      case BookingStep.summary:
        page = CheckoutPage(event);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking ${event.classModel?.name ?? "Unknown"}"),
        leading: currentStep != BookingStep.optionSelection
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => goToPreviousBookingStep(
                  ref,
                  hasQuestions: event.classModel?.questions.isNotEmpty ?? false,
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            CustomStepper(
              hasQuestions: event.classModel?.questions.isNotEmpty ?? false,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: page,
            )),
          ],
        ),
      ),
    );
  }
}

// Platform-specific route transition for booking flow
PageRoute bookingFlowRoute(ClassEvent event) {
  // For web, use the default MaterialPageRoute
  if (kIsWeb) {
    return MaterialPageRoute(
      builder: (context) => BookingFlow(event),
      settings: const RouteSettings(name: 'BookingFlow'),
    );
  }

  // For iOS, slide from bottom
  if (Platform.isIOS) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BookingFlow(event),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Start from bottom
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      settings: const RouteSettings(name: 'BookingFlow'),
    );
  }

  // For Android, slide from right (default Material behavior)
  return MaterialPageRoute(
    builder: (context) => BookingFlow(event),
    settings: const RouteSettings(name: 'BookingFlow'),
  );
}
