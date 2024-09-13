import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow =
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

  final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  // Check if it's today
  if (inputDate == today) {
    return 'Today, ${DateFormat('d MMM').format(dateTime)}';
  }

  // Check if it's tomorrow
  if (inputDate == tomorrow) {
    return 'Tomorrow, ${DateFormat('d MMM').format(dateTime)}';
  }

  // Otherwise, return the weekday and date
  return DateFormat('EEEE, d MMM').format(dateTime);
}

// the same but with time (am/pm)
String formatDateTimeWithTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow =
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

  final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  // Check if it's today
  if (inputDate == today) {
    return 'Today, ${DateFormat('d MMM').format(dateTime)} at ${DateFormat('h:mm a').format(dateTime)}';
  }

  // Check if it's tomorrow
  if (inputDate == tomorrow) {
    return 'Tomorrow, ${DateFormat('d MMM').format(dateTime)} at ${DateFormat('h:mm a').format(dateTime)}';
  }

  // Otherwise, return the weekday and date
  return '${DateFormat('EEEE, d MMM').format(dateTime)} at ${DateFormat('h:mm a').format(dateTime)}';
}

// only time from TimeOfDay as english format (5pm, 5:30pm)
String formatTimeOfDay(TimeOfDay time) {
  final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minutes = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';

  if (time.minute == 0) {
    return '$hours$period'.toLowerCase();
  } else {
    return '$hours:$minutes$period'.toLowerCase();
  }
}

// 0 to monday, 6 to sunday
String getDayOfWeek(int day) {
  switch (day) {
    case 0:
      return 'Monday';
    case 1:
      return 'Tuesday';
    case 2:
      return 'Wednesday';
    case 3:
      return 'Thursday';
    case 4:
      return 'Friday';
    case 5:
      return 'Saturday';
    case 6:
      return 'Sunday';
    default:
      return '';
  }
}
