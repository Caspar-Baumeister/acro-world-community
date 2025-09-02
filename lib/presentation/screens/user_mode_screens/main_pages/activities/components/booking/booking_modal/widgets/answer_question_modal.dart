import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/phone_question_input.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/selectable_card.dart';
import 'package:acroworld/provider/riverpod_provider/event_answer_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnswerQuestionModal extends ConsumerStatefulWidget {
  const AnswerQuestionModal({
    super.key,
    required this.question,
    required this.eventOccurence,
    required this.userId,
  });

  final QuestionModel question;
  final String eventOccurence;
  final String userId;

  @override
  ConsumerState<AnswerQuestionModal> createState() => _AnswerQuestionModalState();
}

class _AnswerQuestionModalState extends ConsumerState<AnswerQuestionModal> {
  late TextEditingController _answerController;
  late TextEditingController _phonePrefixController;
  final List<String> _selectedOptions = <String>[];

  @override
  void initState() {
    _answerController = TextEditingController();
    _phonePrefixController = TextEditingController();
    super.initState();

    final AnswerModel? editAnswer = ref.read(eventAnswerProvider.notifier)
        .getAnswersByQuestionId(widget.question.id!);
    if (editAnswer != null) {
      _answerController.text = editAnswer.answer ?? "";
      if (widget.question.type == QuestionType.phoneNumber) {
        print("dial code: ${editAnswer.countryDialCode}");
        _phonePrefixController.text = editAnswer.countryDialCode ?? "";
        _answerController.text = editAnswer.answer ?? "";
      }
      if (widget.question.type == QuestionType.multipleChoice) {
        _selectedOptions.clear();
        _selectedOptions.addAll(editAnswer.multipleChoiceAnswers!
            .map((e) => e.multipleChoiceOptionId)
            .whereType<String>()
            .toList());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAnswerState = ref.watch(eventAnswerProvider);
    final AnswerModel? editAnswer = ref.read(eventAnswerProvider.notifier)
        .getAnswersByQuestionId(widget.question.id!);

    if (editAnswer != null) {
      print("Edit answer: ${editAnswer.toString()}");
    }

    final QuestionType questionType = widget.question.type ?? QuestionType.text;
    return BaseModal(
      title: widget.question.title ?? "",
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8 -
              MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // question question
              if (questionType != QuestionType.phoneNumber &&
                  widget.question.question != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingLarge),
                  child: Text(
                    widget.question.question!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
              if (questionType == QuestionType.text) ...[
                // answer input
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingLarge,
                      vertical: AppDimensions.spacingMedium),
                  child: InputFieldComponent(
                    controller: _answerController,
                    minLines: 5,
                    maxLines: 20,
                    labelText: "Answer",
                  ),
                ),
              ],
              if (questionType == QuestionType.multipleChoice) ...[
                const SizedBox(height: AppDimensions.spacingMedium),
                widget.question.isMultipleChoice == true
                    ? Padding(
                        // padding only left
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spacingExtraSmall,
                        ),
                        child: Text("(✓) You can choose multiple options",
                            style: Theme.of(context).textTheme.bodyMedium),
                      )
                    : Container(),
                // multiple choice options
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingLarge,
                  ),
                  child: Column(
                    children: widget.question.choices!
                        .map((choice) => SelectableCard(
                              text: choice.optionText ?? "",
                              value: _selectedOptions.contains(choice.id),
                              onPressed: () {
                                if (widget.question.isMultipleChoice != true) {
                                  print("Single choice");
                                  _selectedOptions.clear();
                                }
                                setState(() {
                                  if (!_selectedOptions.contains(choice.id)) {
                                    _selectedOptions.add(choice.id!);
                                  } else {
                                    _selectedOptions.remove(choice.id);
                                  }
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
              ],
              if (questionType == QuestionType.phoneNumber) ...[
                // phone number input
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingLarge,
                      vertical: AppDimensions.spacingMedium),
                  child: PhoneQuestionInput(
                      controller: _answerController,
                      prefixController: _phonePrefixController),
                ),
              ],

              SizedBox(height: AppDimensions.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StandartButton(
                      width: MediaQuery.of(context).size.width * 0.3,
                      text: "Cancel",
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  SizedBox(width: AppDimensions.spacingSmall),
                  StandartButton(
                      width: MediaQuery.of(context).size.width * 0.5,
                      text: editAnswer != null ? "Save" : "Add",
                      isFilled: true,
                      onPressed: () {
                        if (editAnswer != null &&
                            editAnswer.questionId != null) {
                          if (_answerController.text.isEmpty &&
                              widget.question.type !=
                                  QuestionType.multipleChoice) {
                            showErrorToast("Please enter an answer");
                            return;
                          }
                          ref.read(eventAnswerProvider.notifier).updateAnswer(
                              editAnswer.questionId!,
                              AnswerModel(
                                  answer: _answerController.text,
                                  questionId: widget.question.id,
                                  countryDialCode: _phonePrefixController.text,
                                  userId: editAnswer.userId,
                                  eventOccurence: editAnswer.eventOccurence,
                                  id: editAnswer.id,
                                  multipleChoiceAnswers: _selectedOptions
                                      .map((e) => MultipleChoiceAnswerModel(
                                          multipleChoiceOptionId: e,
                                          answerId: editAnswer.id,
                                          userId: editAnswer.userId,
                                          isCorrect: true))
                                      .toList()));
                        } else {
                          if (_answerController.text.isNotEmpty ||
                              questionType == QuestionType.multipleChoice) {
                            ref.read(eventAnswerProvider.notifier).addAnswer(AnswerModel(
                                answer: _answerController.text,
                                countryDialCode: _phonePrefixController.text,
                                eventOccurence: widget.eventOccurence,
                                userId: widget.userId,
                                questionId: widget.question.id,
                                multipleChoiceAnswers: _selectedOptions
                                    .map((e) => MultipleChoiceAnswerModel(
                                        isCorrect: true,
                                        multipleChoiceOptionId: e,
                                        userId: widget.userId))
                                    .toList()));
                          } else {
                            showErrorToast("Please enter an answer");
                            return;
                          }
                        }
                        Navigator.of(context).pop();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
