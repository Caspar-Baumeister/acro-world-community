import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader(
      {super.key,
      required this.className,
      required this.teacherName,
      required this.startDate,
      required this.currentStep,
      required this.endDate});
  // classname
  final String? className;
  final String? teacherName;
  final DateTime startDate;
  final DateTime endDate;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // the class name in the header
        Text(
          className ?? "Unknown Event Name",
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        // the teacher name
        const SizedBox(height: 8.0),
        if (teacherName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              "by $teacherName",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        // the date in the form of "Monday 14.07.24, 12:00 am - 02:00 pm gmt"
        Text(
          "${DateFormat('EEEE dd.MM.yy').format(startDate)}\n${DateFormat('hh:mm a').format(startDate)} - ${DateFormat('hh:mm a').format(endDate)}",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: CustomColors.accentColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
