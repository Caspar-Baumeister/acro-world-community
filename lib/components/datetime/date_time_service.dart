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
  static String getDateStringDifferntDays(
      DateTime startDateTime, DateTime endDateTime) {
    // if the start and end date are in the same month return "12 - 14. Dec"
    if (startDateTime.month == endDateTime.month) {
      return "${startDateTime.day} - ${endDateTime.day}. ${DateFormat.MMM().format(endDateTime)}";
    }
    // if the start and end date are in different months return "12. Dec - 14. Jan"
    return "${startDateTime.day}. ${DateFormat.MMM().format(startDateTime)} - ${endDateTime.day}. ${DateFormat.MMM().format(endDateTime)}";
  }

  // if the start and end date are the same, returns only the start and end time without the date
  static String getTimeString(String? startDate, String? endDate) {
    if (startDate != null && endDate != null) {
      DateTime startDateTime = DateTime.parse(startDate);
      DateTime endDateTime = DateTime.parse(endDate);
      if (startDateTime.day == endDateTime.day &&
          startDateTime.month == endDateTime.month &&
          startDateTime.year == endDateTime.year) {
        return "${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}";
      }
    }
    return "";
  }

  // get the start and end date and returns either the same day or different days
  static String getDateString(String? startDate, String? endDate,
      {bool? onlyTime}) {
    if (startDate != null && endDate != null) {
      DateTime startDateTime = DateTime.parse(startDate);
      DateTime endDateTime = DateTime.parse(endDate);
      if (startDateTime.day == endDateTime.day &&
          startDateTime.month == endDateTime.month &&
          startDateTime.year == endDateTime.year) {
        return onlyTime == true
            ? getTimeString(startDate, endDate)
            : getDateStringSameDay(startDate, endDate);
      }
      return getDateStringDifferntDays(startDateTime, endDateTime);
    }
    return "";
  }
}
