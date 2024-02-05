import 'package:acroworld/utils/text_styles.dart';
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
  final String className;
  final String teacherName;
  final DateTime startDate;
  final DateTime endDate;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // the class name in the header
        Text(
          className,
          style: H24W8,
          textAlign: TextAlign.center,
        ),
        // the teacher name
        const SizedBox(height: 8.0),
        Text(
          teacherName,
          style: H16W3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6.0),
        // the date in the form of "Monday 14.07.24, 12:00 am - 02:00 pm gmt"
        Text(
          "${DateFormat('EEEE dd.MM.yy, hh:mm a').format(startDate)} - ${DateFormat('hh:mm a').format(endDate)}",
          style: H16W3,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
