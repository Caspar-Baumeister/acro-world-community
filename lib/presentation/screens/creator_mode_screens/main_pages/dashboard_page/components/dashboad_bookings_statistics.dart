import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class DashboadBookingsStatistics extends StatelessWidget {
  const DashboadBookingsStatistics(
      {super.key, required this.totalAmountBookings});

  final int totalAmountBookings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(AppPaddings.medium).copyWith(bottom: 0, top: 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorders.smallRadius,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(AppPaddings.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total amount of bookings: $totalAmountBookings",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
