import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_amount_notifies_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_header.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_search_teacher_input_field.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_selected_teachers_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_teacher_suggestion_section.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddings.medium,
      ),
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CommunityStepHeader(),
          const SizedBox(height: AppPaddings.medium),
          // Input field with search suggestions
          CommunityStepSearchTeacherInputField(
              eventCreationAndEditingProvider: eventCreationAndEditingProvider,
              teacherQueryController: teacherQueryController),
          Expanded(
            child: Stack(
              children: [
                CommunityStepSelectedTeachersSection(
                    eventCreationAndEditingProvider:
                        eventCreationAndEditingProvider),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddings.medium),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: CommunityStepTeacherSuggestionSection(
                      query: query,
                      eventCreationAndEditingProvider:
                          eventCreationAndEditingProvider,
                      teacherQueryController: teacherQueryController),
                ),
              ],
            ),
          ),
          CommunityStepAmountNotifiesComponent(
              eventCreationAndEditingProvider: eventCreationAndEditingProvider),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: Responsive.isDesktop(context)
                      ? const BoxConstraints(maxWidth: 200)
                      : null,
                  child: StandartButton(
                    onPressed: () {
                      eventCreationAndEditingProvider.setPage(1);
                      setState(() {});
                    },
                    text: "Previous",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
                const SizedBox(width: AppPaddings.medium),
                Container(
                  constraints: Responsive.isDesktop(context)
                      ? const BoxConstraints(maxWidth: 400)
                      : null,
                  child: StandartButton(
                    onPressed: _onNext,
                    text: "Next",
                    isFilled: true,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppPaddings.small),
          DisplayErrorMessageComponent(errorMessage: _errorMessage)
          // wrap the invited teachers
        ],
      ),
    );
  }

  void _onNext() {
    widget.onFinished();
  }
}
