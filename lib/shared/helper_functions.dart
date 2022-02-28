import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// builds the modal widgets
Future<void> buildMortal(BuildContext context, Widget mordal) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      context: context,
      builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: mordal));
}

String dateToText(DateTime date) {
  int hours = date.difference(DateTime.now()).inHours;
  int days = date.difference(DateTime.now()).inDays;

  if (days == 1) {
    return "Tommorow";
  }
  if (days == 0) {
    return "In ${hours.toString()} hours";
  }
  if (days == -1) {
    return "Yesterday";
  }
  if (days < 7 && days > 0) {
    return "Next ${DateFormat('EEEE').format(date)}";
  }
  if (days > -7 && days < 0) {
    return "Last ${DateFormat('EEEE').format(date)}";
  }
  if (days < 0) {
    return "${(days * -1).toString()} ago";
  }
  if (days > 0) {
    return "In ${days.toString()} days";
  }
  return "";
}
