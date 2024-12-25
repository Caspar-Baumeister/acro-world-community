import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/custom_icon_button.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_category_modal.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/add_or_edit_booking_option_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            eventCreationAndEditingProvider.bookingOptions.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: AppPaddings.large)
                        .copyWith(bottom: AppPaddings.medium),
                    child: InputFieldComponent(
                      controller: _maxAmountTickets,
                      labelText: 'Total amount of tickets',
                      isFootnoteError: false,
                      isNumberInput: true,
                      footnoteText:
                          "How many tickets in total are available for this event, shared across all ticket categories",
                    ),
                  )
                : Container(),
            const SizedBox(height: AppPaddings.medium),
            StandardButton(
                text: 'Add Ticket-Category',
                isFilled: true,
                onPressed: () {
                  buildMortal(context, AddOrEditBookingCategoryModal(
                    onFinished: (BookingCategoryModel bookingCategory) {
                      eventCreationAndEditingProvider.addCategory(
                        bookingCategory,
                      );
                    },
                  ));
                }),
            const SizedBox(height: AppPaddings.medium),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              reverse: false,
              itemCount:
                  eventCreationAndEditingProvider.bookingCategories.length,
              itemBuilder: (context, index) {
                BookingCategoryModel bookingCategory =
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
                          onFinished: (BookingCategoryModel bookingCategory) {
                            eventCreationAndEditingProvider.editCategory(
                              index,
                              bookingCategory,
                            );
                          },
                          bookingCategory: bookingCategory,
                        ),
                      );
                    },
                    onDelete: () {
                      eventCreationAndEditingProvider.removeCategory(
                        index,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCreationCard extends StatelessWidget {
  const CategoryCreationCard(
      {super.key,
      required this.bookingCategory,
      required this.onEdit,
      required this.onDelete});

  final BookingCategoryModel bookingCategory;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);

    return Container(
        padding: const EdgeInsets.all(AppPaddings.medium),
        decoration: BoxDecoration(
          color: CustomColors.secondaryBackgroundColor,
          borderRadius: AppBorders.defaultRadius,
        ),
        child: Column(
          children: [
            // show header with title and description, contingent and edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(bookingCategory.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor)),
                ),
                Text("Amount tickets: ${bookingCategory.contingent}",
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: AppPaddings.small),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(bookingCategory.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: AppPaddings.small),
                  child: CustomIconButton(
                      icon: Icons.edit,
                      onPressed: () {
                        onEdit();
                      }),
                ),
              ],
            ),
            // a line
            const CustomDivider(),
            // show Booking options of provider with category id
            ...eventCreationAndEditingProvider.bookingOptions.where((option) {
              return option.bookingCategoryId == bookingCategory.id;
            }).map(
              (BookingOption e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppPaddings.medium),
                  child: BookingOptionCreationCard(
                    bookingOption: e,
                    onEdit: () {
                      buildMortal(
                          context,
                          AddOrEditBookingOptionModal(
                            onFinished: (BookingOption bookingOption) {
                              eventCreationAndEditingProvider.editBookingOption(
                                eventCreationAndEditingProvider.bookingOptions
                                    .indexOf(e),
                                bookingOption,
                              );
                            },
                            bookingOption: e,
                            categoryID: bookingCategory.id!,
                          ));
                    },
                    onDelete: () {
                      eventCreationAndEditingProvider.removeBookingOption(
                        eventCreationAndEditingProvider.bookingOptions
                            .indexOf(e),
                      );
                    },
                  ),
                );
              },
            ),

            SizedBox(height: AppPaddings.medium),
            // show button to add booking option

            StandardButton(
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
                      ));
                }),
          ],
        ));
  }
}

class BookingOptionCreationCard extends StatelessWidget {
  const BookingOptionCreationCard(
      {super.key,
      required this.bookingOption,
      required this.onEdit,
      required this.onDelete});

  final BookingOption bookingOption;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onEdit();
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: AppBorders.defaultRadius,
            border: Border.all(color: CustomColors.primaryTextColor, width: 1),
          ),
          padding: const EdgeInsets.all(AppPaddings.small),
          child: Row(
            children: [
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
              VerticalDivider(
                color: CustomColors.primaryTextColor,
                thickness: 1,
              ),
              CustomIconButton(
                onPressed: () {
                  onDelete();
                },
                icon: Icons.delete,
              ),
            ],
          )),
    );
  }
}
