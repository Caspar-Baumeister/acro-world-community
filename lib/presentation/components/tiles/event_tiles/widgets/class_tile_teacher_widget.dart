import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/classes/class_teacher_chips.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class ClassTileTeacherWidget extends StatelessWidget {
  const ClassTileTeacherWidget({
    super.key,
    required this.classObject,
  });

  final ClassModel classObject;

  @override
  Widget build(BuildContext context) {
    final List<ClassTeachers> classTeachers =
        classObject.classTeachers?.toList() ?? [];
    return classTeachers.isEmpty
        ? Container(
            height: AppDimensions.avatarSizeMedium,
          )
        : ClassTeacherChips(
            classTeacherList: List<TeacherModel>.from(
              classTeachers.map((e) {
                return e.teacher;
              }).where((element) => element != null),
            ),
          );
  }
}
