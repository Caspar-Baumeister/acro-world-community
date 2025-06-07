import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/custom_check_box.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_category_modal.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/category_creation_card.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';

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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Button to add a new ticket category
            const SizedBox(height: AppPaddings.medium),
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
            const SizedBox(height: AppPaddings.medium),

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: eventCreationAndEditingProvider.isCashAllowed,
                      onTap: () {
                        eventCreationAndEditingProvider
                            .switchAllowCashPayments();
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Allow cash payments.\nCash bookings are automatically marked as confirmed and might block slots for paying users. You'll need to confirm payment manually in your bookings to include it in statistics.",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black87,
                              height: 1.3,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppPaddings.medium),
          ],
        ),
      ),
    );
  }
}
