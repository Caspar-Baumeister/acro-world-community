import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/community/widgets/teacher_card.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityBody extends ConsumerWidget {
  const CommunityBody({
    super.key,
    required this.teachers,
  });

  final List<TeacherModel> teachers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppPaddings.medium),
        ...teachers.where((t) => t.type != "Anonymous").map((teacher) {
          return TeacherCard(
            teacher: teacher,
          );
        }),
      ],
    );
  }
}
