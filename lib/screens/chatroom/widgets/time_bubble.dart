import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeBubble extends StatelessWidget {
  const TimeBubble({Key? key, required this.createdAt}) : super(key: key);
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[200]!,
        ),
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Text(readableTimeString(createdAt)),
    );
  }
}

String readableTimeString(String createdAt) {
  DateTime createdAtDateTime = DateTime.parse(createdAt);
  String displayTime = DateFormat.EEEE().format(createdAtDateTime);
  if (DateTime.now().day == createdAtDateTime.day) {
    displayTime = "Today";
  } else if (DateTime.now().difference(createdAtDateTime).inDays > 7) {
    displayTime = DateFormat.MMMEd().format(createdAtDateTime);
  }
  return displayTime;
}

String readableTimeDateTime(DateTime date) {
  print("difference");
  print(DateTime.now().difference(date).inDays);
  String displayTime = "upcoming ${DateFormat.EEEE().format(date)}";
  if (DateTime.now().day == date.day) {
    displayTime = "Today";
  } else if (DateTime.now().difference(date).inDays.abs() > 6) {
    displayTime = DateFormat.MMMEd().format(date);
  }
  return displayTime;
}
