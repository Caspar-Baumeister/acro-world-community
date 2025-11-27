import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_ticket_section.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_booking_provider.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketStep extends ConsumerStatefulWidget {
  const MarketStep({
    super.key,
    required this.onFinished,
    required this.isEditing,
  });
  final Function onFinished;
  final bool isEditing;

  @override
  ConsumerState<MarketStep> createState() => _MarketStepState();
}

class _MarketStepState extends ConsumerState<MarketStep> {
  late TextEditingController _maxAmountTicketController;

  @override
  void initState() {
    super.initState();
    // add listener to update provider
    _maxAmountTicketController = TextEditingController(text: "20");

    _maxAmountTicketController.addListener(() {
      if (_maxAmountTicketController.text != "") {
        ref
            .read(eventBookingProvider.notifier)
            .setMaxBookingSlots(int.parse(_maxAmountTicketController.text));
      }
    });

    final creatorNotifier = ref.read(creatorProvider.notifier);
    final creatorState = ref.read(creatorProvider);
    if (creatorState.activeTeacher == null) {
      creatorNotifier.setCreatorFromToken().then((success) {
        if (!success) {
          showErrorToast("Session Expired, refreshing session");
          TokenSingletonService().refreshToken().then((value) {
            creatorNotifier.setCreatorFromToken();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Column(
        children: [
          MarketStepTicketSection(),
        ],
      ),
    );
  }
}

void showNoPaymentMethodDialog(BuildContext context, VoidCallback onContinue) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("No Payment Method Selected",
          style: Theme.of(context).textTheme.titleLarge),
      content: Text(
        "Your tickets won’t be visible because they can’t be purchased. "
        "Please enable Stripe or allow cash payments to make them bookable.",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Go back
          child: Text("Back", style: Theme.of(context).textTheme.labelLarge),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onContinue();
          },
          child: Text("Continue without Tickets",
              style: Theme.of(context).textTheme.labelLarge),
        ),
      ],
    ),
  );
}
