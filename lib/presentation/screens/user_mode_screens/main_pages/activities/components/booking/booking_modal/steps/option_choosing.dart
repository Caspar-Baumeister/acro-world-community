import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class OptionChoosingStep extends StatelessWidget {
  const OptionChoosingStep(
      {super.key,
      required this.className,
      required this.classDate,
      required this.classEventId,
      required this.onOptionSelected,
      required this.placesLeft,
      required this.currentOption,
      required this.nextStep,
      required this.bookingCategories,
      this.maxPlaces});
  final String className;
  final DateTime classDate;
  final void Function(String) onOptionSelected;
  final num? placesLeft;
  final num? maxPlaces;
  final String? currentOption;
  final Function nextStep;
  final List<BookingCategoryModel> bookingCategories;
  final String classEventId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // show all categories
        Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...bookingCategories.where((bc) {
                  if (bc.bookingOptions == null || bc.bookingOptions!.isEmpty) {
                    return false;
                  }
                  return true;
                }).map((bookingCategory) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppPaddings.tiny),
                      child: BookingCategorySelectionComponent(
                        bookingCategory: bookingCategory,
                        currentId: currentOption,
                        classEventId: classEventId,
                        onChanged: (id) {
                          onOptionSelected(id);
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        StandardButton(
          text: "Continue",
          onPressed: () {
            if (currentOption != null) {
              nextStep();
            } else {
              showErrorToast(
                "Please select an option to continue booking the class",
              );
            }
          },
          isFilled: true,
          buttonFillColor: CustomColors.accentColor,
          width: double.infinity,
        ),
        placesLeft != null && maxPlaces != null
            ? Padding(
                padding: const EdgeInsets.only(top: AppPaddings.small),
                child: Text(
                  "$placesLeft / $maxPlaces places left",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: placesLeft! <= (maxPlaces! / 2)
                          ? CustomColors.errorTextColor
                          : CustomColors.accentColor),
                ),
              )
            : Container()
      ],
    );
  }
}

class BookingCategorySelectionComponent extends StatelessWidget {
  const BookingCategorySelectionComponent({
    super.key,
    required this.bookingCategory,
    this.currentId,
    required this.onChanged,
    required this.classEventId,
  });

  final BookingCategoryModel bookingCategory;
  final String classEventId;
  final String? currentId;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(AppPaddings.medium),
        decoration: BoxDecoration(
          color: CustomColors.secondaryBackgroundColor,
          borderRadius: AppBorders.defaultRadius,
        ),
        child: FutureBuilder<int?>(
          future: getConfirmedBookingsAggregate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // show header with title and description, contingent and edit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(bookingCategory.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primaryColor)),
                    ),
                    Text(
                        "Amount tickets:  ${snapshot.data != null ? "${snapshot.data}/" : ""}${bookingCategory.contingent}",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                SizedBox(height: AppPaddings.small),
                Text(bookingCategory.description ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium),
                // a line
                const CustomDivider(),
                if (snapshot.data != null &&
                    snapshot.data! >= bookingCategory.contingent)
                  Padding(
                    padding: const EdgeInsets.only(top: AppPaddings.small),
                    child: Text(
                      "No more places left",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: CustomColors.errorTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                if (snapshot.data == null ||
                    snapshot.data! < bookingCategory.contingent)
                  // show Booking options of provider with category id
                  ...bookingCategory.bookingOptions!
                      .map((BookingOption e) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppPaddings.medium),
                            child: BookingOptionSelectionCard(
                              bookingOption: e,
                              value: currentId == e.id,
                              onChanged: onChanged,
                            ),
                          )),
              ],
            );
          },
        ));
  }

  // get aggregate of all confirmed bookings for this category
  Future<int?> getConfirmedBookingsAggregate() async {
    BookingsRepository bookingsRepository =
        BookingsRepository(apiService: GraphQLClientSingleton());

    // get all confirmed bookings for this category
    return bookingsRepository.getConfirmedBookingsForCategoryAggregate(
        bookingCategory.id!, classEventId);
  }
}

class BookingOptionSelectionCard extends StatelessWidget {
  const BookingOptionSelectionCard(
      {super.key,
      required this.bookingOption,
      required this.value,
      required this.onChanged});

  final BookingOption bookingOption;
  final bool value;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(bookingOption.id!);
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: AppBorders.defaultRadius,
            border: Border.all(color: CustomColors.primaryTextColor, width: 1),
          ),
          padding: const EdgeInsets.all(AppPaddings.small),
          child: Row(
            children: [
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: IgnorePointer(
                  child: Checkbox(
                    activeColor: CustomColors.successTextColor,
                    value: value,
                    onChanged: (_) => onChanged(bookingOption.id!),
                  ),
                ),
              ),
              VerticalDivider(
                color: CustomColors.primaryTextColor,
                thickness: 1,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bookingOption.title!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor),
                      maxLines: 2,
                    ),
                    bookingOption.subtitle != null &&
                            bookingOption.subtitle!.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: AppPaddings.small),
                            child: Text(
                              bookingOption.subtitle!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Text(
                '${bookingOption.price != null ? (bookingOption.price! / 100).toStringAsFixed(2) : "n/a"} ${bookingOption.currency.symbol}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: CustomColors.accentColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }
}
