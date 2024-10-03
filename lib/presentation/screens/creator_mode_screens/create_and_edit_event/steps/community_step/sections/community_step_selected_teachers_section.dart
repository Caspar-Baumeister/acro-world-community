import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_option.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:flutter/material.dart';

class CommunityStepSelectedTeachersSection extends StatelessWidget {
  const CommunityStepSelectedTeachersSection({
    super.key,
    required this.eventCreationAndEditingProvider,
  });

  final EventCreationAndEditingProvider eventCreationAndEditingProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      child: Wrap(
        spacing: 3,
        children: eventCreationAndEditingProvider.pendingInviteTeachers
            .map((teacher) {
          return TeacherOption(
            teacher: teacher,
            onDelete: () {
              eventCreationAndEditingProvider
                  .removePendingInviteTeacher(teacher.id!);
            },
          );
        }).toList(),
      ),
    );
  }
}
