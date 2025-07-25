// lib/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/pages/option_choosing_step.dart

import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_option_selection_provider.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_step_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OptionSelectionPage extends ConsumerWidget {
  const OptionSelectionPage({
    super.key,
    required this.classEvent,
  });

  final ClassEvent classEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clas = classEvent.classModel!;

    final bookingCategories = clas.bookingCategories
            ?.where((bc) => (bc.bookingOptions?.isNotEmpty ?? false))
            .toList() ??
        [];

    final selectedOption = ref.watch(selectedBookingOptionIdProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppPaddings.small),
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppPaddings.small),
            itemCount: bookingCategories.length,
            itemBuilder: (context, idx) {
              final category = bookingCategories[idx];
              return BookingCategorySelectionComponent(
                category: category,
                eventId: classEvent.id!,
                current: selectedOption,
                onSelected: (opt) => ref
                    .read(selectedBookingOptionIdProvider.notifier)
                    .state = opt,
              );
            },
          ),
        ),
        const SizedBox(height: AppPaddings.medium),
        StandartButton(
          text: "Continue",
          isFilled: true,
          onPressed: selectedOption == null
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Please select an option to continue booking")),
                  );
                }
              : () {
                  // Determine if there are questions to show
                  final hasQuestions =
                      classEvent.classModel?.questions.isNotEmpty ?? false;

                  // Use the provider's helper function instead of local callback
                  goToNextBookingStep(ref, hasQuestions: hasQuestions);
                },
        ),
        const SizedBox(height: AppPaddings.small),
        if (classEvent.availableBookingSlots != null &&
            classEvent.maxBookingSlots != null)
          Text(
            "${classEvent.availableBookingSlots} / ${classEvent.maxBookingSlots} places left",
            style: TextStyle(
              color: classEvent.availableBookingSlots! <=
                      (classEvent.maxBookingSlots! / 2)
                  ? CustomColors.errorTextColor
                  : CustomColors.accentColor,
            ),
          ),
        const SizedBox(height: AppPaddings.medium),
      ],
    );
  }
}

class BookingCategorySelectionComponent extends ConsumerStatefulWidget {
  const BookingCategorySelectionComponent({
    super.key,
    required this.category,
    required this.eventId,
    required this.current,
    required this.onSelected,
  });

  final BookingCategoryModel category;
  final String eventId;
  final BookingOption? current;
  final void Function(BookingOption) onSelected;

  @override
  ConsumerState<BookingCategorySelectionComponent> createState() =>
      _BookingCategorySelectionComponentState();
}

class _BookingCategorySelectionComponentState
    extends ConsumerState<BookingCategorySelectionComponent> {
  late Future<int> _confirmedFuture;

  @override
  void initState() {
    super.initState();
    _confirmedFuture = _fetchConfirmed();
  }

  Future<int> _fetchConfirmed() async {
    final repo = BookingsRepository(apiService: GraphQLClientSingleton());
    return await repo.getConfirmedBookingsForCategoryAggregate(
            widget.category.id!, widget.eventId) ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final opt = widget.current;
    return FutureBuilder<int>(
      future: _confirmedFuture,
      builder: (context, snap) {
        // Only enable skeletonizer during loading
        final isLoading = snap.connectionState == ConnectionState.waiting;

        if (isLoading) {
          // Show skeleton version during loading
          return Skeletonizer(
            enabled: true,
            child: _buildCategoryContainer(
              context,
              widget.category.contingent,
              0,
              opt,
            ),
          );
        }

        if (snap.hasError) {
          return Text("Error: ${snap.error}");
        }

        final confirmed = snap.data!;
        final remaining = widget.category.contingent - confirmed;
        final soldOut = remaining <= 0;

        // Show actual data when loaded
        return _buildCategoryContainer(
          context,
          widget.category.contingent,
          remaining,
          opt,
          soldOut: soldOut,
        );
      },
    );
  }

  // Extract container building into a separate method for reuse
  Widget _buildCategoryContainer(
    BuildContext context,
    int contingent,
    int remaining,
    BookingOption? opt, {
    bool soldOut = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppPaddings.medium),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBackgroundColor,
        borderRadius: AppBorders.defaultRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.category.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Available: $remaining/$contingent",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (widget.category.description?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(top: AppPaddings.small),
              child: Text(
                widget.category.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: AppPaddings.small),
          const Divider(),
          if (soldOut)
            Center(
              child: Text(
                "Sold out",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: CustomColors.errorTextColor),
              ),
            )
          else
            ...widget.category.bookingOptions!.map((option) {
              final isSelected = opt?.id == option.id;
              return GestureDetector(
                onTap: () => widget.onSelected(option),
                child: Container(
                  margin: const EdgeInsets.only(top: AppPaddings.small),
                  padding: const EdgeInsets.all(AppPaddings.small),
                  decoration: BoxDecoration(
                    borderRadius: AppBorders.defaultRadius,
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.accentColor
                          : CustomColors.lightTextColor,
                      width: 1.5,
                    ),
                    color: isSelected
                        ? CustomColors.accentColor.withOpacity(0.1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? CustomColors.accentColor
                            : CustomColors.lightTextColor,
                      ),
                      const SizedBox(width: AppPaddings.small),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            if (option.subtitle?.isNotEmpty ?? false)
                              Text(option.subtitle!,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Text(
                        "${(option.price! / 100).toStringAsFixed(2)} ${option.currency.symbol}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
