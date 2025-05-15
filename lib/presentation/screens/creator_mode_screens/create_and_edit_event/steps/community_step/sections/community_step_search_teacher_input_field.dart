import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A search field for inviting teachers in the community step,
/// with a contextual tip if the current user hasn’t invited themself yet.
class CommunityStepSearchTeacherInputField extends ConsumerWidget {
  const CommunityStepSearchTeacherInputField({
    super.key,
    required this.eventCreationAndEditingProvider,
    required this.teacherQueryController,
  });

  final EventCreationAndEditingProvider eventCreationAndEditingProvider;
  final TextEditingController teacherQueryController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userRiverpodProvider);

    return userAsync.when(
      loading: () {
        // While loading, show the input without a tip
        return InputFieldComponent(
          controller: teacherQueryController,
          labelText: 'Search for teachers',
          isFootnoteError: false,
          footnoteText: null,
        );
      },
      error: (_, __) {
        // On error, still show the input, but no tip
        return InputFieldComponent(
          controller: teacherQueryController,
          labelText: 'Search for teachers',
          isFootnoteError: false,
          footnoteText: null,
        );
      },
      data: (user) {
        final userId = user?.id;
        final alreadyInvitedYourself = eventCreationAndEditingProvider
            .pendingInviteTeachers
            .any((TeacherModel teacher) => teacher.userId == userId);

        return InputFieldComponent(
          controller: teacherQueryController,
          labelText: 'Search for teachers',
          isFootnoteError: false,
          footnoteText: alreadyInvitedYourself
              ? null
              : 'Tip: invite yourself to the event if you are teaching',
        );
      },
    );
  }
}
