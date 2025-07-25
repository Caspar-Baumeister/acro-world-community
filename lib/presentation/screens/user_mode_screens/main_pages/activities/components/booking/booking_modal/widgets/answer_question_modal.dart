import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/phone_question_input.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/components/selectable_card.dart';
import 'package:acroworld/provider/event_answers_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerQuestionModal extends StatefulWidget {
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
  State<AnswerQuestionModal> createState() => _AnswerQuestionModalState();
}

class _AnswerQuestionModalState extends State<AnswerQuestionModal> {
  late TextEditingController _answerController;
  late TextEditingController _phonePrefixController;
  final List<String> _selectedOptions = <String>[];

  @override
  void initState() {
    _answerController = TextEditingController();
    _phonePrefixController = TextEditingController();
    super.initState();

    final AnswerModel? editAnswer =
        Provider.of<EventAnswerProvider>(context, listen: false)
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
    final provider = Provider.of<EventAnswerProvider>(context);
    final AnswerModel? editAnswer =
        provider.getAnswersByQuestionId(widget.question.id!);

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPaddings.large),
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
                      horizontal: AppPaddings.large,
                      vertical: AppPaddings.medium),
                  child: InputFieldComponent(
                    controller: _answerController,
                    minLines: 5,
                    maxLines: 20,
                    labelText: "Answer",
                  ),
                ),
              ],
              if (questionType == QuestionType.multipleChoice) ...[
                const SizedBox(height: AppPaddings.medium),
                widget.question.isMultipleChoice == true
                    ? Padding(
                        // padding only left
                        padding: const EdgeInsets.only(
                          bottom: AppPaddings.tiny,
                        ),
                        child: Text("(✓) You can choose multiple options",
                            style: Theme.of(context).textTheme.bodyMedium),
                      )
                    : Container(),
                // multiple choice options
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddings.large,
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
                const SizedBox(height: AppPaddings.medium),
              ],
              if (questionType == QuestionType.phoneNumber) ...[
                // phone number input
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppPaddings.large,
                        vertical: AppPaddings.medium),
                    child: PhoneQuestionInput(
                      initialDialCode: _phonePrefixController.text,
                      initialValue: _answerController.text,
                      onChanged: (phone, code) {
                        _answerController.text = phone;
                        _phonePrefixController.text = code;
                      },
                    )),
              ],

              SizedBox(height: AppPaddings.medium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StandartButton(
                      width: MediaQuery.of(context).size.width * 0.3,
                      text: "Cancel",
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  SizedBox(width: AppPaddings.small),
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
                          provider.updateAnswer(
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
                            provider.addAnswer(AnswerModel(
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
