import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/ask_question_modal.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionPage extends ConsumerWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                SizedBox(width: AppDimensions.spacingSmall),
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

class CurrentQuestionSection extends ConsumerWidget {
  const CurrentQuestionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingSmall),
      child: eventState.questions.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spacingExtraLarge),
                child: Text(
                  "No questions added yet, click on the button below to add a question",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ReorderableListView(
              padding: const EdgeInsets.all(AppDimensions.spacingSmall),
              onReorder: (oldIndex, newIndex) {
                ref.read(eventCreationAndEditingProvider.notifier).reorderQuestions(oldIndex, newIndex);
              },
              children: List.generate(eventState.questions.length, (index) {
                final item = eventState.questions[index];
                return Dismissible(
                  key:
                      ValueKey(item.id), // Ensure the key is unique and stable.
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => ref.read(eventCreationAndEditingProvider.notifier).removeQuestion(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Theme.of(context).colorScheme.error,
                    padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingMedium,
                        horizontal: AppDimensions.spacingLarge),
                    child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimary),
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
          horizontal: AppDimensions.spacingMedium,
          vertical: AppDimensions.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
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
