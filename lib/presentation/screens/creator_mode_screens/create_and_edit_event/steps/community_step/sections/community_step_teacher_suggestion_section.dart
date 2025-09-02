import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_suggestions_query.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityStepTeacherSuggestionSection extends ConsumerWidget {
  const CommunityStepTeacherSuggestionSection({
    super.key,
    required this.query,
    required this.teacherQueryController,
  });

  final String query;
  final TextEditingController teacherQueryController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
    return SingleChildScrollView(
      child: query.isNotEmpty
          ? TeacherSuggestionsQuery(
              query: query,
              alreadySelectedIds: eventState
                  .pendingInviteTeachers
                  .map((e) => e.id!)
                  .toList(),
              onTeacherSelected: (TeacherModel teacher) {
                ref.read(eventCreationAndEditingProvider.notifier)
                    .addPendingInviteTeacher(teacher);
                teacherQueryController.clear();
              },
              variables: (String query) {
                return {
                  'limit': 10,
                  'offset': 0,
                  'where': {
                    '_or': [
                      {
                        'name': {'_ilike': '$query%'}
                      },
                      {
                        'user': {
                          'email': {'_ilike': '$query%'}
                        }
                      },
                    ],
                  },
                };
              },
              identifier: 'teachers',
            )
          : Container(),
    );
  }
}
