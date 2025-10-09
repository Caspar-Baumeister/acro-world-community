import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_option.dart';
import 'package:acroworld/provider/riverpod_provider/event_teachers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityStepSelectedTeachersSection extends ConsumerWidget {
  const CommunityStepSelectedTeachersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersState = ref.watch(eventTeachersProvider);

    // Ensure uniqueness by filtering duplicates based on teacher ID
    final uniqueTeachers = <String, TeacherModel>{};
    for (final teacher in teachersState.pendingInviteTeachers) {
      if (teacher.id != null) {
        uniqueTeachers[teacher.id!] = teacher;
      }
    }

    // Build list of widgets: teachers + email invites
    final List<Widget> inviteWidgets = [];

    // Add teacher widgets
    inviteWidgets.addAll(
      uniqueTeachers.values.map((teacher) {
        return TeacherOption(
          teacher: teacher,
          onDelete: () {
            ref
                .read(eventTeachersProvider.notifier)
                .removePendingInviteTeacher(teacher.id!);
          },
        );
      }).toList(),
    );

    // Add email invitation widgets
    inviteWidgets.addAll(
      teachersState.pendingEmailInvites.map((email) {
        return TeacherOption.email(
          email: email,
          onDelete: () {
            ref.read(eventTeachersProvider.notifier).removeEmailInvite(email);
          },
        );
      }).toList(),
    );

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      child: Wrap(
        spacing: 3,
        children: inviteWidgets,
      ),
    );
  }
}
