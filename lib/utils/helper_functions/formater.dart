import 'package:acroworld/data/models/class_event.dart';
//intl
import 'package:intl/intl.dart';

String formatDateRangeForInstructor(DateTime start, DateTime end) {
  var dayFormatter = DateFormat('EEEE');
  var timeFormatter = DateFormat('HH.mm');
  return '${dayFormatter.format(start)}, ${timeFormatter.format(start)}-${timeFormatter.format(end)}';
}

String formatInstructors(List<ClassTeachers>? teachers) {
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

String getDateStringMonthDay(DateTime start) {
  // get the start day, month and time
  var dayFormatter = DateFormat('d');
  var monthFormatter = DateFormat('MMMM');
  var timeFormatter = DateFormat('HH.mm');
  return '${dayFormatter.format(start)} ${monthFormatter.format(start)} ${timeFormatter.format(start)}';
}

String getDatedMMHHmm(DateTime start) {
  // get the start day, month and time
  var dayFormatter = DateFormat('d');
  var monthFormatter = DateFormat('MM');
  // timeformatter as 4.00pm or similar
  var timeFormatter = DateFormat('hh:mm a');
  return '${dayFormatter.format(start)}.${monthFormatter.format(start)} - ${timeFormatter.format(start)}';
}

String getDatedMMYY(DateTime start) {
  // get the start day, month and time
  var dayFormatter = DateFormat('d');
  var monthFormatter = DateFormat('MM');
  var yearFormatter = DateFormat('yy');
  return '${dayFormatter.format(start)}.${monthFormatter.format(start)}.${yearFormatter.format(start)}';
}
