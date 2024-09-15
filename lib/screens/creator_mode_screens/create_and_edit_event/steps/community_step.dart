import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/input/input_field_component.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/creator_mode_screens/create_and_edit_event/components/teacher_option.dart';
import 'package:acroworld/screens/creator_mode_screens/create_and_edit_event/components/teacher_suggestions_query.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityStep extends StatefulWidget {
  const CommunityStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  State<CommunityStep> createState() => _CommunityStepState();
}

class _CommunityStepState extends State<CommunityStep> {
  late TextEditingController teacherQueryController;
  String? _errorMessage;
  String query = '';

  @override
  void initState() {
    super.initState();

    teacherQueryController = TextEditingController();
    teacherQueryController.addListener(() {
      setState(() {
        query = teacherQueryController.text;
      });
    });
  }

  @override
  void dispose() {
    teacherQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EventCreationAndEditingProvider eventCreationAndEditingProvider =
        Provider.of<EventCreationAndEditingProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddings.medium,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPaddings.medium),
              child: Text(
                  "Invite teachers to your event. The more teachers you invite, the more user will see your event.",
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: AppPaddings.medium),
            // Input field with search suggestions
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                print("activeUser: ${userProvider.activeUser?.id}");
                for (var element
                    in eventCreationAndEditingProvider.pendingInviteTeachers) {
                  print("pendingInviteTeachers: ${element.userId}");
                }
                return InputFieldComponent(
                  controller: teacherQueryController,
                  labelText: 'Search for teachers',
                  isFootnoteError: false,
                  footnoteText: eventCreationAndEditingProvider
                          .pendingInviteTeachers
                          .any((TeacherModel teacher) =>
                              teacher.userId == userProvider.activeUser?.id)
                      ? null
                      : 'Tip: invite yourself to the event if you are teaching',
                );
              },
            ),
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: Wrap(
                        spacing: 3,
                        children: eventCreationAndEditingProvider
                            .pendingInviteTeachers
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
                    ),
                    Center(
                        child:
                            StandardButton(onPressed: _onNext, text: 'Next')),
                    const SizedBox(height: AppPaddings.small),
                    _errorMessage != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppPaddings.medium,
                            ),
                            child: Text(
                              _errorMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: CustomColors.errorTextColor),
                            ),
                          )
                        : const SizedBox(height: AppPaddings.medium),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.medium),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
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
                  ),
                ),
              ],
            ),
            // wrap the invited teachers
          ],
        ),
      ),
    );
  }

  void _onNext() {
    widget.onFinished();
  }
}
