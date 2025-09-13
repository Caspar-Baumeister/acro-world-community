import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/modals/ask_question_modal.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/modal_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionsStep extends ConsumerWidget {
  const QuestionsStep({super.key, required this.onFinished});

  final Function onFinished;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingMedium,
              ),
              child: Column(
                children: [
                  Text(
                    'Event Questions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    'Add questions that participants need to answer when booking your event.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Questions list
            Expanded(
              child: CurrentQuestionSection(),
            ),
            
            const SizedBox(height: AppDimensions.spacingMedium),
            
            // Add Question button
            Container(
              constraints: Responsive.isDesktop(context)
                  ? const BoxConstraints(maxWidth: 200)
                  : null,
              child: ModernButton(
                onPressed: () {
                  buildMortal(context, AskQuestionModal());
                },
                text: "Add Question",
                isFilled: true,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentQuestionSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingSmall),
      child: eventState.questions.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingExtraLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppDimensions.spacingMedium),
                    Text(
                      "No questions added yet",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacingSmall),
                    Text(
                      "Click 'Add Question' below to create questions for participants",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ReorderableListView(
              padding: const EdgeInsets.all(AppDimensions.spacingSmall),
              onReorder: (oldIndex, newIndex) {
                ref
                    .read(eventCreationAndEditingProvider.notifier)
                    .reorderQuestions(oldIndex, newIndex);
              },
              children: List.generate(eventState.questions.length, (index) {
                final question = eventState.questions[index];
                return Card(
                  key: ValueKey(question.id),
                  margin: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingSmall,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.drag_handle,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      question.question ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      question.type?.toString() ?? 'Text',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        onPressed: () {
                          buildMortal(
                            context,
                            AskQuestionModal(
                              editQuestion: question,
                            ),
                          );
                        },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () {
                            ref
                                .read(eventCreationAndEditingProvider.notifier)
                                .removeQuestion(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }
}
