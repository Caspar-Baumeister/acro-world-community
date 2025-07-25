import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnaireAnswersNotifier
    extends StateNotifier<Map<String, AnswerModel>> {
  QuestionnaireAnswersNotifier() : super({});

  void setTextAnswer(
      String questionId, String userId, String eventId, String value) {
    state = {
      ...state,
      questionId: AnswerModel(
        questionId: questionId,
        userId: userId,
        answer: value,
        eventOccurence: eventId,
      ),
    };
  }

  void setPhoneAnswer({
    required String questionId,
    required String userId,
    required String eventId,
    required String value,
    required String dialCode,
  }) {
    state = {
      ...state,
      questionId: AnswerModel(
        questionId: questionId,
        userId: userId,
        answer: value,
        countryDialCode: dialCode,
        eventOccurence: eventId,
      ),
    };
  }

  void setMultipleChoice({
    required String questionId,
    required String userId,
    required String eventId,
    required List<String> selectedOptionIds,
  }) {
    state = {
      ...state,
      questionId: AnswerModel(
        questionId: questionId,
        userId: userId,
        eventOccurence: eventId,
        multipleChoiceAnswers: selectedOptionIds
            .map((id) => MultipleChoiceAnswerModel(
                  multipleChoiceOptionId: id,
                  userId: userId,
                  isCorrect: true,
                ))
            .toList(),
      ),
    };
  }

  AnswerModel? getAnswer(String questionId) => state[questionId];

  bool areRequiredQuestionsAnswered(List<QuestionModel> questions) {
    for (var q in questions) {
      if (q.isRequired == true) {
        final answer = state[q.id];
        final hasText = (answer?.answer?.trim().isNotEmpty ?? false);
        final hasChoice = (answer?.multipleChoiceAnswers?.isNotEmpty ?? false);
        final hasPhone = (q.type == QuestionType.phoneNumber &&
            answer?.answer?.isNotEmpty == true &&
            answer?.countryDialCode?.isNotEmpty == true);
        if (!(hasText || hasChoice || hasPhone)) return false;
      }
    }
    return true;
  }

  List<AnswerModel> get allAnswers => state.values.toList();
}

final questionnaireAnswersProvider = StateNotifierProvider.autoDispose<
    QuestionnaireAnswersNotifier, Map<String, AnswerModel>>(
  (ref) => QuestionnaireAnswersNotifier(),
);
