import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityStepSearchTeacherInputField extends StatelessWidget {
  const CommunityStepSearchTeacherInputField({
    super.key,
    required this.eventCreationAndEditingProvider,
    required this.teacherQueryController,
  });

  final EventCreationAndEditingProvider eventCreationAndEditingProvider;
  final TextEditingController teacherQueryController;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        for (var element
            in eventCreationAndEditingProvider.pendingInviteTeachers) {}
        return InputFieldComponent(
          controller: teacherQueryController,
          labelText: 'Search for teachers',
          isFootnoteError: false,
          footnoteText: eventCreationAndEditingProvider.pendingInviteTeachers
                  .any((TeacherModel teacher) =>
                      teacher.userId == userProvider.activeUser?.id)
              ? null
              : 'Tip: invite yourself to the event if you are teaching',
        );
      },
    );
  }
}
