import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_create_stripe_account_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_ticket_section.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketStep extends StatefulWidget {
  const MarketStep({
    super.key,
    required this.onFinished,
    required this.isEditing,
  });
  final Function onFinished;
  final bool isEditing;

  @override
  State<MarketStep> createState() => _MarketStepState();
}

class _MarketStepState extends State<MarketStep> {
  late TextEditingController _maxAmountTicketController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final eventCreationProvider =
        Provider.of<EventCreationAndEditingProvider>(context, listen: false);
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
        Provider.of<CreatorProvider>(context, listen: false);
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
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);
    // Userprovider is only for the ticket section.
    // We'll check if the user teacher account has a stripe account
    CreatorProvider creatorProvider = Provider.of<CreatorProvider>(context);

    bool isStripeEnabled = creatorProvider.activeTeacher != null &&
        creatorProvider.activeTeacher!.stripeId != null &&
        creatorProvider.activeTeacher!.isStripeEnabled == true;

    return Column(
      children: [
        creatorProvider.isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : isStripeEnabled // if stripe is enabled, don't need to show infobax
                ? SizedBox.shrink()
                : const MarketStepCreateStripeAccountSection(),

        const SizedBox(height: AppPaddings.medium),
        MarketStepTicketSection(
            eventCreationAndEditingProvider: eventCreationAndEditingProvider),
        // enable cash payment section
        // checkbox with enable cash payment
        const SizedBox(height: AppPaddings.medium),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StandartButton(
              onPressed: () {
                eventCreationAndEditingProvider.setPage(2);
                setState(() {});
              },
              text: "Previous",
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            const SizedBox(width: AppPaddings.medium),
            StandartButton(
              onPressed: _onNext,
              text: widget.isEditing ? "Update Event" : "Create Event",
              loading: isLoading,
              isFilled: true,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ],
        ),
        const SizedBox(height: AppPaddings.large),
      ],
    );
  }

  void _onNext() async {
    final eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context, listen: false);

    final creatorProvider = Provider.of<CreatorProvider>(context);

    bool isStripeEnabled = creatorProvider.activeTeacher != null &&
        creatorProvider.activeTeacher!.stripeId != null &&
        creatorProvider.activeTeacher!.isStripeEnabled == true;
    // if neither stripe is enabled nor cash payments, show alert with informations, that your tickets will not be shown since they cannot be bought by cash or direct payment. Please either enable stripe or add cash payment option.
    // Add the button, that you can continue without tickets or go back
    if (!isStripeEnabled &&
        !eventCreationAndEditingProvider.isCashAllowed &&
        eventCreationAndEditingProvider.bookingCategories.isNotEmpty) {
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
    if (eventCreationAndEditingProvider.bookingOptions.isNotEmpty &&
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
      title: const Text("No Payment Method Selected"),
      content: const Text(
        "Your tickets won’t be visible because they can’t be purchased. "
        "Please enable Stripe or allow cash payments to make them bookable.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Go back
          child: const Text("Back"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onContinue();
          },
          child: const Text("Continue without Tickets"),
        ),
      ],
    ),
  );
}
