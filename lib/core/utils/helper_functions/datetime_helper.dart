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
