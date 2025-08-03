import 'package:acroworld/data/models/class_event.dart';
//intl
import 'package:intl/intl.dart';

// get the date in the format of Thursday, 10.23 - 12.00
String formatDateRangeForInstructor(DateTime start, DateTime end) {
  var dayFormatter = DateFormat('EEEE');
  var timeFormatter = DateFormat('HH.mm');
  return '${dayFormatter.format(start)}, ${timeFormatter.format(start)}-${timeFormatter.format(end)}';
}

String formatInstructors(List<ClassTeacher>? teachers) {
  if (teachers == null || teachers.isEmpty) {
    return "";
  }
  if (teachers.length <= 3) {
    if (teachers.length == 1) {
      return "By ${teachers[0].teacher!.name!}";
    } else if (teachers.length == 2) {
      return "By "
          '${teachers[0].teacher!.name!} and ${teachers[1].teacher!.name!}';
    } else {
      return "By "
          '${teachers[0].teacher!.name!}, ${teachers[1].teacher!.name!} and ${teachers[2].teacher!.name!}';
    }
  } else {
    return "By "
        '${teachers[0].teacher!.name!}, ${teachers[1].teacher!.name!}, ${teachers[2].teacher!.name!}, and more';
  }
}

// get the date in the format of 10 December 2021
String getDateStringMonthDay(DateTime start) {
  // get the start day, month and time
  var dayFormatter = DateFormat('d');
  var monthFormatter = DateFormat('MMMM');
  var timeFormatter = DateFormat('HH.mm');
  return '${dayFormatter.format(start)} ${monthFormatter.format(start)} ${timeFormatter.format(start)}';
}

// get the date in the format of 10.12 - 4.00pm
String getDatedMMHHmm(DateTime start) {
  // get the start day, month and time
  var dayFormatter = DateFormat('d');
  var monthFormatter = DateFormat('MM');
  var yearFormatter = DateFormat('yy');
  // timeformatter as 4.00pm or similar
  var timeFormatter = DateFormat('hh:mm a');
  return '${dayFormatter.format(start)}.${monthFormatter.format(start)}.${yearFormatter.format(start)} - ${timeFormatter.format(start)}';
}

// get the date in the format of 10.12.21
String getDatedMMYY(DateTime start) {
  // get the start day, month and time
  var dayFormatter = DateFormat('d');
  var monthFormatter = DateFormat('MM');
  var yearFormatter = DateFormat('yy');
  return '${dayFormatter.format(start)}.${monthFormatter.format(start)}.${yearFormatter.format(start)}';
}

// get the date in the format of: Thursday, 10.December 2021 1pm - 2pm or
// Thursday, 10.December 2021 1pm - 12.January 2022 2pm
// depending on start and end date
String getFormattedDateRange(DateTime start, DateTime end, {bool? isNewLine}) {
  // get the start day, month and time
  var dayFormatter = DateFormat('EEEE');
  var dayFormatterShort = DateFormat('d');
  var monthFormatter = DateFormat('MMMM');
  var yearFormatter = DateFormat('yyyy');
  // get the english time formatter for 12 hour time
  var timeFormatter = DateFormat('h:mm a');
  // get the end day, month and time
  var endDayFormatterShort = DateFormat('d');
  var endMonthFormatter = DateFormat('MMMM');
  // check if the start and end date are the same
  if (start.day == end.day &&
      start.month == end.month &&
      start.year == end.year) {
    return '${dayFormatter.format(start)}, ${dayFormatterShort.format(start)}.${monthFormatter.format(start)} ${yearFormatter.format(start)}, ${isNewLine == true ? "\n" : ""}${timeFormatter.format(start)} - ${timeFormatter.format(end)}';
  } else {
    return '${dayFormatter.format(start)}, ${dayFormatterShort.format(start)}.${monthFormatter.format(start)} ${yearFormatter.format(start)}, ${isNewLine == true ? "\n" : ""}${timeFormatter.format(start)} - ${endDayFormatterShort.format(end)}.${endMonthFormatter.format(end)} ${yearFormatter.format(end)} ${timeFormatter.format(end)}';
  }
}

// get the date in the format of 10.12
String getDatedMM(DateTime start) {
  // get the start day, month and time
  var dayFormatter = DateFormat('d');
  var monthFormatter = DateFormat('MM');
  return '${dayFormatter.format(start)}.${monthFormatter.format(start)}';
}
