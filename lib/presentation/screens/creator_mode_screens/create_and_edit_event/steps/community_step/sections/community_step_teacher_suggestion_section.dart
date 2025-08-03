import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_suggestions_query.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:flutter/material.dart';

class CommunityStepTeacherSuggestionSection extends StatelessWidget {
  const CommunityStepTeacherSuggestionSection({
    super.key,
    required this.query,
    required this.eventCreationAndEditingProvider,
    required this.teacherQueryController,
  });

  final String query;
  final EventCreationAndEditingProvider eventCreationAndEditingProvider;
  final TextEditingController teacherQueryController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: query.isNotEmpty
          ? TeacherSuggestionsQuery(
              query: query,
              alreadySelectedIds: eventCreationAndEditingProvider
                  .pendingInviteTeachers
                  .map((e) => e.id!)
                  .toList(),
              onTeacherSelected: (TeacherModel teacher) {
                eventCreationAndEditingProvider
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
