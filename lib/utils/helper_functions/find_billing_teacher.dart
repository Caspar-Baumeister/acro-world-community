import 'package:acroworld/models/class_event.dart';

ClassTeachers? findFirstTeacherOrNull(List<ClassTeachers>? classTeachers) {
  for (var teacher in classTeachers ?? []) {
    if (teacher.teacher?.isStripeEnabled == true &&
        teacher.teacher?.stripeId != null) {
      return teacher;
    }
  }
  return null;
}
