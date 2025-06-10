import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/ask_question_modal.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                StandartButton(
                  text: "Done",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                SizedBox(width: AppPaddings.small),
                StandartButton(
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
      child: provider.questions.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppPaddings.extraLarge),
                child: Text(
                  "No questions added yet, click on the button below to add a question",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ReorderableListView(
              padding: const EdgeInsets.all(AppPaddings.small),
              onReorder: (oldIndex, newIndex) {
                provider.reorderQuestions(oldIndex, newIndex);
              },
              children: List.generate(provider.questions.length, (index) {
                final item = provider.questions[index];
                return Dismissible(
                  key:
                      ValueKey(item.id), // Ensure the key is unique and stable.
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => provider.removeQuestion(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: CustomColors.errorBorderColor,
                    padding: EdgeInsets.symmetric(
                        vertical: AppPaddings.medium,
                        horizontal: AppPaddings.large),
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
        AskQuestionModal(editQuestion: question),
      ),
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Row(
                    children: [
                      if (question.isRequired ?? false)
                        Text("* ",
                            style: Theme.of(context).textTheme.titleMedium),
                      Expanded(
                        child: Text(
                          question.title ?? "",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  /// Question text
                  if (question.question != null &&
                      question.question!.isNotEmpty)
                    Text(
                      question.question!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 6),

                  /// Type
                  Text(
                    "Type: ${question.type?.name ?? ""}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[700]),
                  ),

                  /// Choices (for multiple choice only)
                  if (question.type == QuestionType.multipleChoice &&
                      question.choices != null &&
                      question.choices!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: question.choices!.map((choice) {
                        return Text("• ${choice.optionText}",
                            style: Theme.of(context).textTheme.bodySmall);
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            /// Drag handle icon
            const Center(
              child: Icon(Icons.drag_handle),
            )
          ],
        ),
      ),
    );
  }
}
