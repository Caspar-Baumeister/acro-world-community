import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/phone_question_input.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/selectable_card.dart';
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
  final List<String> _selectedOptions = <String>[];

  @override
  void initState() {
    _answerController = TextEditingController();
    super.initState();

    final AnswerModel? editAnswer =
        Provider.of<EventAnswerProvider>(context, listen: false)
            .getAnswersByQuestionId(widget.question.id!);
    if (editAnswer != null) {
      _answerController.text = editAnswer.answer ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventAnswerProvider>(context);
    final AnswerModel? editAnswer =
        provider.getAnswersByQuestionId(widget.question.id!);

    final QuestionType questionType = widget.question.type ?? QuestionType.text;
    return BaseModal(
      title: widget.question.title ?? "",
      child: Column(
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
                  horizontal: AppPaddings.large, vertical: AppPaddings.medium),
              child: InputFieldComponent(
                controller: _answerController,
                minLines: 5,
                maxLines: 20,
                labelText: "Answer",
              ),
            ),
          ],
          if (questionType == QuestionType.multipleChoice) ...[
            // multiple choice options
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddings.large, vertical: AppPaddings.medium),
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
          ],
          if (questionType == QuestionType.phoneNumber) ...[
            // phone number input
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddings.large, vertical: AppPaddings.medium),
              child: PhoneQuestionInput(controller: _answerController),
            ),
          ],

          SizedBox(height: AppPaddings.medium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StandardButton(
                  width: MediaQuery.of(context).size.width * 0.3,
                  text: "Cancel",
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              SizedBox(width: AppPaddings.small),
              StandardButton(
                  width: MediaQuery.of(context).size.width * 0.5,
                  text: editAnswer != null ? "Edit" : "Add",
                  isFilled: true,
                  onPressed: () {
                    if (editAnswer != null && editAnswer.questionId != null) {
                      if (_answerController.text.isEmpty) {
                        showErrorToast("Please enter an answer");
                        return;
                      }
                      provider.updateAnswer(
                          editAnswer.questionId!,
                          AnswerModel(
                              answer: _answerController.text,
                              questionId: widget.question.id,
                              userId: editAnswer.userId,
                              eventOccurence: editAnswer.eventOccurence,
                              id: editAnswer.id));
                    } else {
                      if (_answerController.text.isNotEmpty) {
                        provider.addAnswer(AnswerModel(
                            answer: _answerController.text,
                            eventOccurence: widget.eventOccurence,
                            userId: widget.userId,
                            questionId: widget.question.id));
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
    );
  }
}
