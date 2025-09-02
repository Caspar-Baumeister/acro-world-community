import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_ticket_section.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final eventCreationProvider =
        ref.read(eventCreationAndEditingProvider.notifier);
    // add listener to update provider
    _maxAmountTicketController = TextEditingController(
        text: eventCreationProvider.maxBookingSlots == null
            ? "20"
            : eventCreationProvider.maxBookingSlots.toString());

    _maxAmountTicketController.addListener(() {
      if (_maxAmountTicketController.text != "") {
        eventCreationProvider.maxBookingSlots =
            int.parse(_maxAmountTicketController.text);
      }
    });

    final creatorProvider =
        ref.read(creatorProvider.notifier);
    if (creatorProvider.activeTeacher == null) {
      creatorProvider.setCreatorFromToken().then((success) {
        if (!success) {
          showErrorToast("Session Expired, refreshing session");
          TokenSingletonService().refreshToken().then((value) {
            creatorProvider.setCreatorFromToken();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
    // Userprovider is only for the ticket section.

    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Column(
        children: [
          MarketStepTicketSection(
              eventCreationAndEditingProvider: eventCreationAndEditingProvider),
          // enable cash payment section
          // checkbox with enable cash payment
          const SizedBox(height: AppDimensions.spacingMedium),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: Responsive.isDesktop(context)
                    ? const BoxConstraints(maxWidth: 200)
                    : null,
                child: StandartButton(
                  onPressed: () {
                    ref.read(eventCreationAndEditingProvider.notifier).setPage(2);
                    setState(() {});
                  },
                  text: "Previous",
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              Container(
                constraints: Responsive.isDesktop(context)
                    ? const BoxConstraints(maxWidth: 400)
                    : null,
                child: StandartButton(
                  onPressed: _onNext,
                  text: widget.isEditing ? "Update Event" : "Create Event",
                  loading: isLoading,
                  isFilled: true,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
        ],
      ),
    );
  }

  void _onNext() async {
    final eventCreationAndEditingProvider =
        ref.read(eventCreationAndEditingProvider.notifier);

    final creatorProvider =
        ref.read(creatorProvider.notifier);

    bool isStripeEnabled = creatorProvider.activeTeacher != null &&
        creatorProvider.activeTeacher!.stripeId != null &&
        creatorProvider.activeTeacher!.isStripeEnabled == true;
    // if neither stripe is enabled nor cash payments, show alert with informations, that your tickets will not be shown since they cannot be bought by cash or direct payment. Please either enable stripe or add cash payment option.
    // Add the button, that you can continue without tickets or go back
    if (!isStripeEnabled &&
        !eventState.isCashAllowed &&
        eventState.bookingCategories.isNotEmpty) {
      showNoPaymentMethodDialog(context, () async {
        // if user continues without tickets, we just call the onFinished callback
        // and don't add any tickets to the event
        setState(() {
          isLoading = true;
        });
        await widget.onFinished();
        setState(() {
          isLoading = false;
        });
      });
      return;
    }
    // if ticket was added but no amount was set, stop the user
    if (eventState.bookingOptions.isNotEmpty &&
        _maxAmountTicketController.text.isEmpty) {
      showErrorToast("Please set the amount of tickets");
      return;
    }
    setState(() {
      isLoading = true;
    });
    await widget.onFinished();
    setState(() {
      isLoading = false;
    });
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
