import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/custom_icon_button.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_option_modal.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/booking_option_creation_card.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A card that displays a booking category (e.g., "VIP Tickets")
/// and its associated booking options. It also provides edit/delete
/// actions for the category and buttons to add/edit/delete booking options.
class CategoryCreationCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventCreationAndEditingProvider);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              // Category contingent (how many tickets available for this category)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingSmall,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  "Tickets: ${bookingCategory.contingent}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSmall),

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
              const SizedBox(width: AppDimensions.spacingSmall),

              // Edit/Delete buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconButton(
                    icon: Icons.edit,
                    onPressed: onEdit,
                  ),
                  const SizedBox(width: AppDimensions.spacingSmall),
                  CustomIconButton(
                    icon: Icons.delete,
                    onPressed: () {
                      // Warn user if there are any booking options associated with this category
                      final hasAssociatedTickets = eventState.bookingOptions
                          .any((option) =>
                              option.bookingCategoryId == bookingCategory.id);

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
            children: eventState.bookingOptions
                .where(
                    (option) => option.bookingCategoryId == bookingCategory.id)
                .map((option) {
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.spacingMedium),
                child: BookingOptionCreationCard(
                  bookingOption: option,
                  onEdit: () {
                    // Trigger a modal to edit this booking option
                    buildMortal(
                      context,
                      AddOrEditBookingOptionModal(
                        onFinished: (BookingOption updatedOption) {
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .editBookingOption(
                                eventState.bookingOptions.indexOf(option),
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
                    final index = eventState.bookingOptions.indexOf(option);
                    ref
                        .read(eventCreationAndEditingProvider.notifier)
                        .removeBookingOption(index);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimensions.spacingMedium),

          // Button to add a new booking option to this category - smaller icon button
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  buildMortal(
                    context,
                    AddOrEditBookingOptionModal(
                      onFinished: (BookingOption bookingOption) {
                        ref
                            .read(eventCreationAndEditingProvider.notifier)
                            .addBookingOption(bookingOption);
                      },
                      categoryID: bookingCategory.id!,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMedium,
                    vertical: AppDimensions.spacingSmall,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: AppDimensions.iconSizeSmall,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppDimensions.spacingSmall),
                      Text(
                        'Add Ticket',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
