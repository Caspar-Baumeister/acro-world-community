import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_ticket_section.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketStep extends StatefulWidget {
  const MarketStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  State<MarketStep> createState() => _MarketStepState();
}

class _MarketStepState extends State<MarketStep> {
  final TextEditingController _maxAmountTicketController =
      TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // add listener to update provider
    _maxAmountTicketController.addListener(() {
      Provider.of<EventCreationAndEditingProvider>(context, listen: false)
          .maxBookingSlots = int.parse(_maxAmountTicketController.text);
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

    return Column(
      children: [
        creatorProvider.isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : creatorProvider.activeTeacher != null &&
                    creatorProvider.activeTeacher!.stripeId != null &&
                    creatorProvider.activeTeacher!.isStripeEnabled == true
                ? MarketStepTicketSection(
                    eventCreationAndEditingProvider:
                        eventCreationAndEditingProvider,
                    maxAmountTickets: _maxAmountTicketController)
                : const MarketStepCreateStripeAccountSection(),
        const SizedBox(height: AppPaddings.medium),
        StandardButton(
          onPressed: _onNext,
          text: 'Create Event',
          loading: isLoading,
        ),
        const SizedBox(height: AppPaddings.large),
      ],
    );
  }

  void _onNext() async {
    setState(() {
      isLoading = true;
    });
    await widget.onFinished();
    setState(() {
      isLoading = false;
    });
  }
}

class MarketStepCreateStripeAccountSection extends StatelessWidget {
  const MarketStepCreateStripeAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.medium),
      child: Column(
        children: [
          Text(
            "To directly sell tickets in the app, you need to connect a Stripe account.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppPaddings.medium),
          StandardButton(
            onPressed: () {},
            text: 'Connect Stripe Account',
          ),
        ],
      ),
    );
  }
}
