import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppPaddings.small, vertical: AppPaddings.tiny),
      margin: const EdgeInsets.all(AppPaddings.tiny),
      decoration: BoxDecoration(
        color: () {
          switch (bookingStatus) {
            case "Cancelled":
              return CustomColors.errorTextColor;
            case "Confirmed":
            case "Completed":
              return CustomColors.successTextColor;
            case "Pending":
              return DARK_GREY;
            case "WaitingForPayment":
              return CustomColors.warningColor;
            default:
              return DARK_GREY;
          }
        }(),
        // rounded corners
        borderRadius: BorderRadius.circular(20),
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
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
