import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/custom_icon_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_option_modal.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/booking_option_creation_card.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A card that displays a booking category (e.g., "VIP Tickets")
/// and its associated booking options. It also provides edit/delete
/// actions for the category and buttons to add/edit/delete booking options.
class CategoryCreationCard extends StatelessWidget {
  const CategoryCreationCard({
    super.key,
    required this.bookingCategory,
    required this.onEdit,
    required this.onDelete,
  });

  /// The booking category data model for this card.
  final BookingCategoryModel bookingCategory;

  /// Callback triggered when the category should be edited.
  final VoidCallback onEdit;

  /// Callback triggered when the category should be deleted.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);

    return Container(
      padding: const EdgeInsets.all(AppPaddings.medium),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBackgroundColor,
        borderRadius: AppBorders.defaultRadius,
      ),
      child: Column(
        children: [
          // Header section: Category title, contingent, and action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category title
              Flexible(
                child: Text(
                  bookingCategory.name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primaryColor,
                      ),
                ),
              ),
              // Category contingent (how many tickets available for this category)
              Text(
                "Tickets: ${bookingCategory.contingent}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppPaddings.small),

          // Description and Edit/Delete buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category description
              Flexible(
                child: Text(
                  bookingCategory.description ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: AppPaddings.small),

              // Edit/Delete buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconButton(
                    icon: Icons.edit,
                    onPressed: onEdit,
                  ),
                  const SizedBox(width: AppPaddings.small),
                  CustomIconButton(
                    icon: Icons.delete,
                    onPressed: () {
                      // Warn user if there are any booking options associated with this category
                      final hasAssociatedTickets =
                          eventCreationAndEditingProvider.bookingOptions
                              .any(
                                  (option) =>
                                      option.bookingCategoryId ==
                                      bookingCategory.id);

                      if (hasAssociatedTickets) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                                'You are about to delete a ticket category that has tickets associated with it. Are you sure you want to proceed?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onDelete();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        onDelete();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          // Divider between category info and booking options
          const CustomDivider(),

          // Show booking options for this category
          Column(
            children: eventCreationAndEditingProvider.bookingOptions
                .where(
                    (option) => option.bookingCategoryId == bookingCategory.id)
                .map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppPaddings.medium),
                child: BookingOptionCreationCard(
                  bookingOption: option,
                  onEdit: () {
                    // Trigger a modal to edit this booking option
                    buildMortal(
                      context,
                      AddOrEditBookingOptionModal(
                        onFinished: (BookingOption updatedOption) {
                          eventCreationAndEditingProvider.editBookingOption(
                            eventCreationAndEditingProvider.bookingOptions
                                .indexOf(option),
                            updatedOption,
                          );
                        },
                        bookingOption: option,
                        categoryID: bookingCategory.id!,
                      ),
                    );
                  },
                  onDelete: () {
                    // Remove the booking option from the provider
                    final index = eventCreationAndEditingProvider.bookingOptions
                        .indexOf(option);
                    eventCreationAndEditingProvider.removeBookingOption(index);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppPaddings.medium),

          // Button to add a new booking option to this category
          StandartButton(
            text: 'Add Ticket',
            onPressed: () {
              buildMortal(
                context,
                AddOrEditBookingOptionModal(
                  onFinished: (BookingOption bookingOption) {
                    eventCreationAndEditingProvider.addBookingOption(
                      bookingOption,
                    );
                  },
                  categoryID: bookingCategory.id!,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
