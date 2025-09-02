import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_option.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityStepSelectedTeachersSection extends ConsumerWidget {
  const CommunityStepSelectedTeachersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      child: Wrap(
        spacing: 3,
        children: eventState.pendingInviteTeachers.map((teacher) {
          return TeacherOption(
            teacher: teacher,
            onDelete: () {
              ref
                  .read(eventCreationAndEditingProvider.notifier)
                  .removePendingInviteTeacher(teacher.id!);
            },
          );
        }).toList(),
      ),
    );
  }
}
