import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/custom_icon_button.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:flutter/material.dart';

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
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1),
          ),
          padding: const EdgeInsets.all(AppDimensions.spacingSmall),
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
                          color: Theme.of(context).colorScheme.primary),
                      maxLines: 2,
                    ),
                    bookingOption.subtitle != null &&
                            bookingOption.subtitle!.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: AppDimensions.spacingSmall),
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
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold),
              ),
              VerticalDivider(
                color: Theme.of(context).colorScheme.onSurface,
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
