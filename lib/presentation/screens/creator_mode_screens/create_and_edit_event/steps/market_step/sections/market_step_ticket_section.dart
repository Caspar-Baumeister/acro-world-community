import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/presentation/components/custom_check_box.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_category_modal.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/components/category_creation_card.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/market_step/sections/market_step_create_stripe_account_section.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This widget represents the "Ticket" section of the "Market Step"
/// in your event creation or editing flow. It shows existing categories
/// and allows adding new ticket categories.
class MarketStepTicketSection extends ConsumerWidget {
  const MarketStepTicketSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
    // Userprovider is only for the ticket section.
    // We'll check if the user teacher account has a stripe account
    final creatorState = ref.watch(creatorProvider);

    bool isStripeEnabled = creatorState.activeTeacher != null &&
        creatorState.activeTeacher!.stripeId != null &&
        creatorState.activeTeacher!.isStripeEnabled == true;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Explanation section with info button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLarge),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.all(AppDimensions.spacingMedium),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ticket Categories & Tickets",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingSmall),
                          Text(
                            "Categories like 'Early Bird' or 'Teacher' can have multiple ticket types. For example, Early Bird can have 'Full Festival', 'One Day', etc.",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        size: AppDimensions.iconSizeSmall,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Understanding Ticket Categories"),
                            content: const Text(
                              "Ticket categories help you organize different types of tickets for your event:\n\n"
                              "• Categories (like 'Early Bird', 'Teacher', 'VIP') set the total number of tickets available\n"
                              "• Each category can have multiple ticket types (like 'Full Festival', 'One Day', 'Weekend Pass')\n"
                              "• This helps you manage different pricing and availability for different groups\n\n"
                              "Example: 'Early Bird' category with 100 tickets total, containing:\n"
                              "• Early Bird Full Festival (50 tickets)\n"
                              "• Early Bird One Day (30 tickets)\n"
                              "• Early Bird Weekend Pass (20 tickets)",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Got it"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            
            // List of existing categories
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: eventState.bookingCategories.length,
              itemBuilder: (context, index) {
                final bookingCategory = eventState.bookingCategories[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingLarge,
                  ).copyWith(bottom: AppDimensions.spacingLarge),
                  child: CategoryCreationCard(
                    bookingCategory: bookingCategory,
                    onEdit: () {
                      buildMortal(
                        context,
                        AddOrEditBookingCategoryModal(
                          onFinished: (BookingCategoryModel updatedCategory) {
                            // Update category in the provider
                            // The provider logic should also update the total tickets internally.
                            ref
                                .read(eventCreationAndEditingProvider.notifier)
                                .editCategory(
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
                      ref
                          .read(eventCreationAndEditingProvider.notifier)
                          .removeCategory(index);
                    },
                  ),
                );
              },
            ),
            // Add category button - smaller icon button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLarge),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            buildMortal(
                              context,
                              AddOrEditBookingCategoryModal(
                                onFinished: (BookingCategoryModel bookingCategory) {
                                  ref
                                      .read(eventCreationAndEditingProvider.notifier)
                                      .addCategory(bookingCategory);
                                },
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingMedium,
                              vertical: AppDimensions.spacingSmall,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: AppDimensions.iconSizeSmall,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: AppDimensions.spacingSmall),
                                Text(
                                  'Add Category',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingLarge),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLarge),
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                padding: const EdgeInsets.all(AppDimensions.spacingMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCheckBox(
                      isChecked: eventState.isCashAllowed,
                      onTap: () {
                        ref
                            .read(eventCreationAndEditingProvider.notifier)
                            .switchAllowCashPayments();
                      },
                    ),
                    const SizedBox(width: AppDimensions.spacingMedium),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Allow cash payments",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(
                              width: AppDimensions.spacingExtraSmall),
                          Builder(
                            builder: (context) => IconButton(
                              icon: Icon(Icons.info_outline,
                                  size: AppDimensions.iconSizeSmall),
                              tooltip: "More info",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Allow cash payments"),
                                    content: const Text(
                                      "Cash bookings automatically create a 'to be paid' object in your booking overview and might block slots for paying users. You'll need to confirm cash payment manually in your bookings to include them in statistics.",
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
            const SizedBox(height: AppDimensions.spacingSmall),
            creatorState.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : isStripeEnabled // if stripe is enabled, don't need to show infobax
                    ? SizedBox.shrink()
                    : const MarketStepCreateStripeAccountSection(),

            const SizedBox(height: AppDimensions.spacingMedium),
          ],
        ),
      ),
    );
  }
}
