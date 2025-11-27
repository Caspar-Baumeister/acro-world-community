import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/presentation/components/buttons/custom_icon_button.dart';
import 'package:acroworld/theme/app_dimensions.dart';
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
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppDimensions.spacingMedium),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bookingOption.title!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bookingOption.subtitle != null &&
                        bookingOption.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        bookingOption.subtitle!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSmall),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${bookingOption.price != null ? (bookingOption.price! / 100).toStringAsFixed(2) : "n/a"} ${bookingOption.currency.symbol}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  CustomIconButton(
                    onPressed: () {
                      onDelete();
                    },
                    icon: Icons.delete_outline,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
