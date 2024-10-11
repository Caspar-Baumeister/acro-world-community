import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/floating_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_option_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

class MarketStepTicketSection extends StatelessWidget {
  const MarketStepTicketSection({
    super.key,
    required this.eventCreationAndEditingProvider,
    required TextEditingController maxAmountTickets,
  }) : _maxAmountTickets = maxAmountTickets;

  final EventCreationAndEditingProvider eventCreationAndEditingProvider;
  final TextEditingController _maxAmountTickets;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          StandardButton(
              text: 'Add Tickets',
              onPressed: () {
                buildMortal(context, AddOrEditBookingOptionModal(
                  onFinished: (BookingOption bookingOption) {
                    eventCreationAndEditingProvider.addBookingOption(
                      bookingOption,
                    );
                  },
                ));
              }),
          const SizedBox(height: AppPaddings.medium),
          eventCreationAndEditingProvider.bookingOptions.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPaddings.large)
                          .copyWith(bottom: AppPaddings.medium),
                  child: InputFieldComponent(
                    controller: _maxAmountTickets,
                    labelText: 'Amount of tickets',
                    isFootnoteError: false,
                    isNumberInput: true,
                    footnoteText:
                        "How many tickets in total are available for this event",
                  ),
                )
              : Container(),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                reverse: false,
                itemCount:
                    eventCreationAndEditingProvider.bookingOptions.length,
                itemBuilder: (context, index) {
                  BookingOption bookingOption =
                      eventCreationAndEditingProvider.bookingOptions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.large,
                    ),
                    child: FloatingButton(
                        insideText: "",
                        onPressed: () {
                          buildMortal(
                              context,
                              AddOrEditBookingOptionModal(
                                onFinished: (BookingOption bookingOption) {
                                  eventCreationAndEditingProvider
                                      .editBookingOption(
                                    index,
                                    bookingOption,
                                  );
                                },
                                bookingOption: bookingOption,
                              ));
                        },
                        headerText: "",
                        insideWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(bookingOption.title!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.primaryColor)),
                                IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      eventCreationAndEditingProvider
                                          .removeBookingOption(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: CustomColors.errorTextColor,
                                    ))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                bookingOption.subtitle != null &&
                                        bookingOption.subtitle!.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppPaddings.small),
                                        child: Text(
                                          bookingOption.subtitle!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  '${bookingOption.price != null ? (bookingOption.price! / 100).toStringAsFixed(2) : "n/a"} ${bookingOption.currency.symbol}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: CustomColors.accentColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppPaddings.small),
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
