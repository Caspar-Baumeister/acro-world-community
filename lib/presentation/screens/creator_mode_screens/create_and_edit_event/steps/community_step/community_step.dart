import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_amount_notifies_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_header.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_search_teacher_input_field.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_selected_teachers_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_teacher_suggestion_section.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityStep extends ConsumerStatefulWidget {
  const CommunityStep({super.key, required this.onFinished});
  final Function onFinished;

  @override
  ConsumerState<CommunityStep> createState() => _CommunityStepState();
}

class _CommunityStepState extends ConsumerState<CommunityStep> {
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMedium,
      ),
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CommunityStepHeader(),
          SizedBox(height: AppDimensions.spacingMedium),
          // Input field with search suggestions
          CommunityStepSearchTeacherInputField(
              teacherQueryController: teacherQueryController),
          Expanded(
            child: Stack(
              children: [
                CommunityStepSelectedTeachersSection(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMedium),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: CommunityStepTeacherSuggestionSection(
                      query: query,
                      teacherQueryController: teacherQueryController),
                ),
              ],
            ),
          ),
          CommunityStepAmountNotifiesComponent(),
          DisplayErrorMessageComponent(errorMessage: _errorMessage)
          // wrap the invited teachers
        ],
      ),
    );
  }

}
