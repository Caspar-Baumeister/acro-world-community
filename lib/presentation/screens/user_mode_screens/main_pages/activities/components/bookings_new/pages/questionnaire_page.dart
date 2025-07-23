import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/phone_question_input.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/booking/booking_modal/widgets/selectable_card.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/booking_step_provider.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/activities/components/bookings_new/provider/questionnaire_answers_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuestionnairePage extends ConsumerWidget {
  final ClassEvent classEvent;

  const QuestionnairePage({super.key, required this.classEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = classEvent.classModel?.questions ?? [];
    final answersNotifier = ref.read(questionnaireAnswersProvider.notifier);
    final areAllAnswered = ref.watch(
      questionnaireAnswersProvider.select(
        (answers) => answersNotifier.areRequiredQuestionsAnswered(questions),
      ),
    );

    final userAsync = ref.watch(userRiverpodProvider);

    return Skeletonizer(
      enabled: userAsync.isLoading,
      child: userAsync.when(
        data: (user) => _buildContent(
            context, ref, questions, areAllAnswered, user?.id ?? ""),
        loading: () => const SizedBox(),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<QuestionModel> questions,
    bool areAllAnswered,
    String userId,
  ) {
    final eventId = classEvent.id ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          _stepHeader(classEvent),
          const SizedBox(height: 20),
          for (final question in questions) ...[
            _buildQuestionWidget(ref, question, userId, eventId),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 12),
          StandartButton(
            text: "Continue",
            isFilled: true,
            disabled: !areAllAnswered,
            onPressed: () => goToNextBookingStep(ref, hasQuestions: true),
          ),
          const SizedBox(height: 12),
          Text(
            "${classEvent.availableBookingSlots} / ${classEvent.maxBookingSlots} places left",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _stepHeader(ClassEvent event) {
    return Column(
      children: [
        Text(event.classModel?.name ?? "",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text("by ${event.classModel?.owner?.teacher?.name ?? "Unknown"}",
            style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        Row(
          children: [
            _stepCircle(1, true),
            _line(),
            _stepCircle(2, true),
            _line(),
            _stepCircle(3, false),
          ],
        ),
      ],
    );
  }

  Widget _stepCircle(int number, bool active) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: active ? Colors.green : Colors.grey[300],
      child: Text("$number",
          style: TextStyle(color: active ? Colors.white : Colors.black)),
    );
  }

  Widget _line() =>
      Expanded(child: Container(height: 1, color: Colors.grey[300]));

  Widget _buildQuestionWidget(
    WidgetRef ref,
    QuestionModel question,
    String userId,
    String eventId,
  ) {
    final notifier = ref.read(questionnaireAnswersProvider.notifier);
    final answer = ref
        .watch(questionnaireAnswersProvider.select((map) => map[question.id]));

    switch (question.type) {
      case QuestionType.text:
        // Create a controller with the current answer value
        final controller = TextEditingController(text: answer?.answer ?? "");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.question ?? "",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            InputFieldComponent(
              labelText: question.title ?? "Your answer",
              controller:
                  controller, // Use the controller instead of initialValue
              onFieldSubmitted: (val) => notifier.setTextAnswer(
                question.id!,
                userId,
                eventId,
                val ?? "",
              ),
              onEditingComplete: () => notifier.setTextAnswer(
                question.id!,
                userId,
                eventId,
                controller.text,
              ),
            ),
          ],
        );

      case QuestionType.phoneNumber:
        return PhoneQuestionInput(
          initialValue: answer?.answer,
          initialDialCode: answer?.countryDialCode,
          onChanged: (phone, code) => notifier.setPhoneAnswer(
            questionId: question.id!,
            userId: userId,
            eventId: eventId,
            value: phone,
            dialCode: code,
          ),
        );

      case QuestionType.multipleChoice:
        final selected = answer?.multipleChoiceAnswers
                ?.map((e) => e.multipleChoiceOptionId)
                .whereType<String>()
                .toList() ??
            [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.question ?? "",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Column(
              children: question.choices!.map((choice) {
                final selectedThis = selected.contains(choice.id);
                return SelectableCard(
                  text: choice.optionText ?? "",
                  value: selectedThis,
                  onPressed: () {
                    final newSelection = List<String>.from(selected);
                    if (question.isMultipleChoice == true) {
                      selectedThis
                          ? newSelection.remove(choice.id!)
                          : newSelection.add(choice.id!);
                    } else {
                      newSelection
                        ..clear()
                        ..add(choice.id!);
                    }
                    notifier.setMultipleChoice(
                      questionId: question.id!,
                      userId: userId,
                      eventId: eventId,
                      selectedOptionIds: newSelection,
                    );
                  },
                );
              }).toList(),
            ),
          ],
        );

      default:
        return const Text("Unsupported question type");
    }
  }
}
