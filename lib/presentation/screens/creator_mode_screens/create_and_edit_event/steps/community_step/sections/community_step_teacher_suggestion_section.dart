import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/teacher_suggestions_query.dart';
import 'package:acroworld/provider/riverpod_provider/event_teachers_provider.dart';
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
    final teachersState = ref.watch(eventTeachersProvider);
    final notifier = ref.read(eventTeachersProvider.notifier);

    // Check if query is a valid email
    final isValidEmail = _isValidEmail(query);

    return SingleChildScrollView(
      child: query.isNotEmpty
          ? Column(
              children: [
                TeacherSuggestionsQuery(
                  query: query,
                  alreadySelectedIds: teachersState.pendingInviteTeachers
                      .map((e) => e.id!)
                      .toList(),
                  onTeacherSelected: (TeacherModel teacher) {
                    notifier.addPendingInviteTeacher(teacher);
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
                  showEmailInviteOption: isValidEmail,
                  onEmailInvite: isValidEmail
                      ? () {
                          notifier.addEmailInvite(query);
                          teacherQueryController.clear();
                        }
                      : null,
                )
              ],
            )
          : Container(),
    );
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
