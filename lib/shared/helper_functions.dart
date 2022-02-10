import 'package:intl/intl.dart';

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
