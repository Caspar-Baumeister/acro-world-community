import 'package:intl/intl.dart';

class DateTimeService {
  // get the start and end date of the event and returns something like "12. Dec * 12:00 - 14:00" using intl package
  static String getDateStringSameDay(String? startDate, String? endDate) {
    if (startDate != null && endDate != null) {
      DateTime startDateTime = DateTime.parse(startDate);
      DateTime endDateTime = DateTime.parse(endDate);
      return "${startDateTime.day}. ${DateFormat.MMM().format(startDateTime)} \u2022 ${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}";
    }
    return "";
  }

  // get the start and end date of the event and returns something like "12 - 14. Dec", if the event is in the same month, or "12. Dec - 14. Jan" if the event is in different months
  static String getDateStringDifferntDays(String? startDate, String? endDate) {
    if (startDate != null && endDate != null) {
      DateTime startDateTime = DateTime.parse(startDate);
      DateTime endDateTime = DateTime.parse(endDate);
      String endTimeString = endDateTime.day.toString();
      if (endDateTime.month != startDateTime.month) {
        endTimeString =
            "${endDateTime.day} ${DateFormat.MMM().format(endDateTime)}";
      }
      if (startDateTime.day == endDateTime.day &&
          startDateTime.month == endDateTime.month &&
          startDateTime.year == endDateTime.year) {
        return startDateTime.day.toString();
      }
      return "${startDateTime.day} - $endTimeString";
    }
    return "";
  }

  // get the start and end date and returns either the same day or different days
  static String getDateString(String? startDate, String? endDate) {
    if (startDate != null && endDate != null) {
      DateTime startDateTime = DateTime.parse(startDate);
      DateTime endDateTime = DateTime.parse(endDate);
      if (startDateTime.day == endDateTime.day &&
          startDateTime.month == endDateTime.month &&
          startDateTime.year == endDateTime.year) {
        return getDateStringSameDay(startDate, endDate);
      }
      return getDateStringDifferntDays(startDate, endDate);
    }
    return "";
  }
}
