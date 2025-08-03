import 'package:acroworld/data/models/class_event.dart';

ClassTeacher? findFirstTeacherOrNull(List<ClassTeacher>? classTeachers) {
  for (var teacher in classTeachers ?? []) {
    if (teacher.teacher?.isStripeEnabled == true &&
        teacher.teacher?.stripeId != null) {
      return teacher;
    }
  }
  return null;
}
