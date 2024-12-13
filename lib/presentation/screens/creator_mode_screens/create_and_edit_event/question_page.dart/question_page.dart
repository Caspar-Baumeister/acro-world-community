import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/modals/base_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
        makeScrollable: false,
        appBar: CustomAppbarSimple(title: 'Question'),
        child: Column(
          children: [
            Expanded(child: CurrentQuestionSection()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StandardButton(
                  text: "Done",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                SizedBox(width: AppPaddings.small),
                StandardButton(
                  text: "Add Question",
                  onPressed: () {
                    buildMortal(context, AskQuestionModal());
                  },
                  width: MediaQuery.of(context).size.width * 0.5,
                  isFilled: true,
                ),
              ],
            ),
          ],
        ));
  }
}

class CurrentQuestionSection extends StatelessWidget {
  const CurrentQuestionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventCreationAndEditingProvider>(context);
    return Container(
      padding: EdgeInsets.all(AppPaddings.small),
      child: ReorderableListView(
        padding: const EdgeInsets.all(AppPaddings.small),
        onReorder: (oldIndex, newIndex) {
          provider.reorderQuestions(oldIndex, newIndex);
        },
        children: List.generate(provider.questions.length, (index) {
          final item = provider.questions[index];
          return Dismissible(
            key: ValueKey(item.id), // Ensure the key is unique and stable.
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => provider.removeQuestion(index),
            background: Container(
              alignment: Alignment.centerRight,
              color: CustomColors.errorBorderColor,
              padding: EdgeInsets.symmetric(
                  vertical: AppPaddings.medium, horizontal: AppPaddings.large),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: QuestionCard(question: item),
          );
        }),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final QuestionModel question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => buildMortal(
          context,
          AskQuestionModal(
            editQuestion: question,
          )),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPaddings.medium,
          vertical: AppPaddings.small,
        ),
        decoration: BoxDecoration(
          color: CustomColors.backgroundColor,
          borderRadius: AppBorders.defaultRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.title ?? "",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: AppPaddings.small),
                  Text(
                    question.question ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Center(
              child: Icon(Icons.drag_handle),
            )
          ],
        ),
      ),
    );
  }
}

class AskQuestionModal extends StatefulWidget {
  const AskQuestionModal({super.key, this.editQuestion});

  final QuestionModel? editQuestion;

  @override
  State<AskQuestionModal> createState() => _AskQuestionModalState();
}

class _AskQuestionModalState extends State<AskQuestionModal> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isRequired = false;

  @override
  void initState() {
    if (widget.editQuestion != null) {
      _questionController.text = widget.editQuestion?.question ?? "";
      _titleController.text = widget.editQuestion?.title ?? "";
      _isRequired = widget.editQuestion?.isRequired ?? false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get the new position when adding a new question
    final int newPosition =
        Provider.of<EventCreationAndEditingProvider>(context).questions.length;
    return BaseModal(
        child: Column(
      children: [
        Text("Ask a question"),
        SizedBox(height: AppPaddings.medium),
        InputFieldComponent(
          controller: _titleController,
          labelText: "Question title",
        ),
        SizedBox(height: AppPaddings.medium),
        InputFieldComponent(
          controller: _questionController,
          labelText: "Your question",
          minLines: 4,
          maxLines: 10,
        ),
        SizedBox(height: AppPaddings.medium),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Is this a required question?"),
            SizedBox(width: AppPaddings.small),
            Checkbox(
                value: _isRequired,
                onChanged: (value) {
                  setState(() {
                    _isRequired = value ?? false;
                  });
                })
          ],
        ),
        SizedBox(height: AppPaddings.large),
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
                text: widget.editQuestion != null ? "Edit" : "Add",
                isFilled: true,
                onPressed: () {
                  final provider = Provider.of<EventCreationAndEditingProvider>(
                      context,
                      listen: false);

                  if (widget.editQuestion != null &&
                      widget.editQuestion!.id == null) {
                    showErrorToast(
                        "No id for this question. Remove it and create a new one please");
                  } else if (widget.editQuestion != null &&
                      widget.editQuestion!.id != null) {
                    provider.editQuestion(
                        widget.editQuestion!.id!,
                        QuestionModel(
                            question: _questionController.text,
                            title: _titleController.text,
                            isRequired: _isRequired,
                            id: widget.editQuestion!.id!));
                  } else {
                    provider.addQuestion(QuestionModel(
                        question: _questionController.text,
                        title: _titleController.text,
                        isRequired: _isRequired,
                        position: newPosition,
                        // generate a random id using uuid package

                        id: Uuid().v4()));
                  }
                  Navigator.of(context).pop();
                }),
          ],
        )
      ],
    ));
  }
}
