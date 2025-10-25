import 'package:acroworld/data/models/event/question_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for event questions information
class EventQuestionsState {
  final List<QuestionModel> questions;
  final List<QuestionModel> oldQuestions;
  final bool isLoading;
  final String? errorMessage;

  const EventQuestionsState({
    this.questions = const [],
    this.oldQuestions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  EventQuestionsState copyWith({
    List<QuestionModel>? questions,
    List<QuestionModel>? oldQuestions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventQuestionsState(
      questions: questions ?? this.questions,
      oldQuestions: oldQuestions ?? this.oldQuestions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for event questions information
class EventQuestionsNotifier extends StateNotifier<EventQuestionsState> {
  EventQuestionsNotifier() : super(const EventQuestionsState());

  /// Add question
  void addQuestion(QuestionModel question) {
    final questions = List<QuestionModel>.from(state.questions);
    questions.add(question);
    state = state.copyWith(questions: questions);
  }

  /// Remove question
  void removeQuestion(int index) {
    final questions = List<QuestionModel>.from(state.questions);
    if (index >= 0 && index < questions.length) {
      questions.removeAt(index);
      state = state.copyWith(questions: questions);
    }
  }

  /// Update question
  void updateQuestion(int index, QuestionModel question) {
    final questions = List<QuestionModel>.from(state.questions);
    if (index >= 0 && index < questions.length) {
      questions[index] = question;
      state = state.copyWith(questions: questions);
    }
  }

  /// Edit question in list by ID
  void editQuestion(String id, QuestionModel question) {
    final questions = List<QuestionModel>.from(state.questions);
    final index = questions.indexWhere((q) => q.id == id);
    if (index != -1) {
      questions[index] = question;
      state = state.copyWith(questions: questions);
    }
  }

  /// Reorder questions
  void reorderQuestions(int oldIndex, int newIndex) {
    final questions = List<QuestionModel>.from(state.questions);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = questions.removeAt(oldIndex);
    questions.insert(newIndex, item);
    state = state.copyWith(questions: questions);
  }

  /// Set all questions data at once
  void setQuestionsData({
    required List<QuestionModel> questions,
    required List<QuestionModel> oldQuestions,
  }) {
    state = state.copyWith(
      questions: questions,
      oldQuestions: oldQuestions,
    );
  }

  /// Reset state
  void reset() {
    state = const EventQuestionsState();
  }

  /// Set from template data
  void setFromTemplate({
    required List<QuestionModel> questions,
  }) {
    state = state.copyWith(
      questions: questions,
      oldQuestions: questions, // Set as old questions for editing
    );
  }

  /// Set old questions (snapshot for deletion tracking)
  void setOldQuestions(List<QuestionModel> questions) {
    state = state.copyWith(oldQuestions: questions);
  }
}

/// Provider for event questions information
final eventQuestionsProvider =
    StateNotifierProvider<EventQuestionsNotifier, EventQuestionsState>((ref) {
  return EventQuestionsNotifier();
});
