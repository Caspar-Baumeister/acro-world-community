import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_amount_notifies_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_header.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_search_teacher_input_field.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_selected_teachers_section.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/steps/community_step/sections/community_step_teacher_suggestion_section.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
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
    final eventState = ref.watch(eventState);
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
              eventState: eventState,
              teacherQueryController: teacherQueryController),
          Expanded(
            child: Stack(
              children: [
                CommunityStepSelectedTeachersSection(
                    eventState:
                        eventState),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMedium),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: CommunityStepTeacherSuggestionSection(
                      query: query,
                      eventState:
                          eventState,
                      teacherQueryController: teacherQueryController),
                ),
              ],
            ),
          ),
          CommunityStepAmountNotifiesComponent(
              eventState: eventState),
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
                      ref.read(eventState.notifier).setPage(1);
                      setState(() {});
                    },
                    text: "Previous",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMedium),
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
          const SizedBox(height: AppDimensions.spacingMedium),
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
