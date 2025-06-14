import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/custom_check_box.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_category_modal.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/category_creation_card.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_create_stripe_account_section.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This widget represents the "Ticket" section of the "Market Step"
/// in your event creation or editing flow. It shows existing categories
/// and allows adding new ticket categories.
class MarketStepTicketSection extends StatelessWidget {
  const MarketStepTicketSection({
    super.key,
    required this.eventCreationAndEditingProvider,
  });

  /// Provider responsible for handling all event creation and editing logic,
  /// including the list of `BookingCategoryModel` and `BookingOption`.
  final EventCreationAndEditingProvider eventCreationAndEditingProvider;

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

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // List of existing categories
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  eventCreationAndEditingProvider.bookingCategories.length,
              itemBuilder: (context, index) {
                final bookingCategory =
                    eventCreationAndEditingProvider.bookingCategories[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddings.large,
                  ).copyWith(bottom: AppPaddings.large),
                  child: CategoryCreationCard(
                    bookingCategory: bookingCategory,
                    onEdit: () {
                      buildMortal(
                        context,
                        AddOrEditBookingCategoryModal(
                          onFinished: (BookingCategoryModel updatedCategory) {
                            // Update category in the provider
                            // The provider logic should also update the total tickets internally.
                            eventCreationAndEditingProvider.editCategory(
                              index,
                              updatedCategory,
                            );
                          },
                          bookingCategory: bookingCategory,
                        ),
                      );
                    },
                    onDelete: () {
                      // Remove category from the provider
                      // The provider logic should also update the total tickets internally.
                      eventCreationAndEditingProvider.removeCategory(index);
                    },
                  ),
                );
              },
            ),
            StandartButton(
              text: 'Add Ticket-Category',
              isFilled: true,
              onPressed: () {
                buildMortal(
                  context,
                  AddOrEditBookingCategoryModal(
                    onFinished: (BookingCategoryModel bookingCategory) {
                      // Add a new category to the provider.
                      // The provider logic should also update the total tickets internally.
                      eventCreationAndEditingProvider.addCategory(
                        bookingCategory,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: AppPaddings.small),
            // little infobox if no categories are added yet
            if (eventCreationAndEditingProvider.bookingCategories.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPaddings.large),
                child: Text(
                  "Ticket categories are used to limit the number of tickets available for any group of tickets like Early Bird, Regular, Teacher or Helpers. You need to add at least one category to be able to create tickets.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ),
            const SizedBox(height: AppPaddings.medium),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPaddings.large),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(AppPaddings.medium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCheckBox(
                      isChecked: eventCreationAndEditingProvider.isCashAllowed,
                      onTap: () {
                        eventCreationAndEditingProvider
                            .switchAllowCashPayments();
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Allow cash payments",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                          ),
                          const SizedBox(width: 4),
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.info_outline, size: 18),
                              tooltip: "More info",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Allow cash payments"),
                                    content: const Text(
                                      "Cash bookings are automatically marked as confirmed and might block slots for paying users. You'll need to confirm cash payment manually in your bookings to include them in statistics.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppPaddings.small),
            creatorProvider.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : isStripeEnabled // if stripe is enabled, don't need to show infobax
                    ? SizedBox.shrink()
                    : const MarketStepCreateStripeAccountSection(),

            const SizedBox(height: AppPaddings.medium),
          ],
        ),
      ),
    );
  }
}
