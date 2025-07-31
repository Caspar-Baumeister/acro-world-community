import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BookingStatusTile extends StatelessWidget {
  const BookingStatusTile({
    super.key,
    required this.bookingStatus,
    required this.bookingStatusText,
  });

  final String bookingStatus;
  final String bookingStatusText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingSmall,
          vertical: AppDimensions.spacingExtraSmall),
      margin: EdgeInsets.all(AppDimensions.spacingExtraSmall),
      decoration: BoxDecoration(
        color: () {
          switch (bookingStatus) {
            case "Cancelled":
              return Theme.of(context).colorScheme.error;
            case "Confirmed":
            case "Completed":
              return Theme.of(context).colorScheme.primary;
            case "Pending":
              return Theme.of(context).colorScheme.outline;
            case "WaitingForPayment":
              return Theme.of(context).extension<AppCustomColors>()!.warning;
            default:
              return Theme.of(context).colorScheme.outline;
          }
        }(),
        // rounded corners
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Center(
        child: Text(
          () {
            switch (bookingStatus) {
              case "Cancelled":
                return "Cancelled";
              case "Confirmed":
                return "Confirmed";
              case "Completed":
                return "Completed";
              case "Pending":
                return "Pending";
              case "WaitingForPayment":
                return "Waiting for Payment";
              default:
                return "Unknown";
            }
          }(),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
