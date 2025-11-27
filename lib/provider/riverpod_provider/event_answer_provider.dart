import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/repositories/event_forms_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for event answers
class EventAnswerState {
  final List<AnswerModel> answers;
  final List<AnswerModel> oldAnswers;
  final bool isLoading;
  final String? error;

  const EventAnswerState({
    this.answers = const [],
    this.oldAnswers = const [],
    this.isLoading = false,
    this.error,
  });

  EventAnswerState copyWith({
    List<AnswerModel>? answers,
    List<AnswerModel>? oldAnswers,
    bool? isLoading,
    String? error,
  }) {
    return EventAnswerState(
      answers: answers ?? this.answers,
      oldAnswers: oldAnswers ?? this.oldAnswers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier for event answers
class EventAnswerNotifier extends StateNotifier<EventAnswerState> {
  EventAnswerNotifier() : super(const EventAnswerState());

  /// Test constructor for unit tests
  EventAnswerNotifier.test() : super(const EventAnswerState());

  /// Initialize answers from database
  Future<void> initAnswers(String userId, String eventOccurenceId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final repository = EventFormsRepository(apiService: GraphQLClientSingleton());
      final answers = await repository.getAnswersForUserAndEvent(
        userId,
        eventOccurenceId,
      );

      state = state.copyWith(
        answers: answers,
        oldAnswers: List<AnswerModel>.from(answers),
        isLoading: false,
      );
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Mutate all answers
  Future<bool> mutateAnswers() async {
    try {
      final repository = EventFormsRepository(apiService: GraphQLClientSingleton());
      await repository.identifyAnswerUpdates(state.answers, state.oldAnswers);
      return true;
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      return false;
    }
  }

  /// Add answer to the list
  void addAnswer(AnswerModel answer) {
    CustomErrorHandler.logDebug(
        "adding answer with multiple choice answers: ${answer.multipleChoiceAnswers}");
    final newAnswers = List<AnswerModel>.from(state.answers)..add(answer);
    state = state.copyWith(answers: newAnswers);
  }

  /// Get answers by question id
  AnswerModel? getAnswersByQuestionId(String questionId) {
    if (doesQuestionIdHaveAnswer(questionId)) {
      return state.answers.firstWhere((element) => element.questionId == questionId);
    }
    return null;
  }

  /// Check if question id has an answer
  bool doesQuestionIdHaveAnswer(String questionId) {
    return state.answers.any((element) => element.questionId == questionId);
  }

  /// Update answer
  void updateAnswer(String questionId, AnswerModel answer) {
    final newAnswers = List<AnswerModel>.from(state.answers);
    final index = newAnswers.indexWhere((element) => element.questionId == questionId);
    if (index != -1) {
      newAnswers[index] = answer;
      state = state.copyWith(answers: newAnswers);
    }
  }

  /// Check if all questions have answers
  bool doAllQuestionsHaveAnswers(List<String> questionIds) {
    return questionIds.every((element) => doesQuestionIdHaveAnswer(element));
  }

  /// Clear all answers
  void clearAnswers() {
    state = state.copyWith(
      answers: [],
      oldAnswers: [],
      error: null,
    );
  }
}

/// Provider for event answers state
final eventAnswerProvider = 
    StateNotifierProvider<EventAnswerNotifier, EventAnswerState>((ref) {
  return EventAnswerNotifier();
});
