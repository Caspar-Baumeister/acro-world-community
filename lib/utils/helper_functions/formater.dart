import 'package:acroworld/models/class_event.dart';
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
