import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/repositories/event_forms_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';

class EventAnswerProvider extends ChangeNotifier {
  final List<AnswerModel> _answers = [];
  final List<AnswerModel> _oldAnswers = [];

  // in the init, get all the answers from the database
  Future<void> initAnswers(String userId, String eventOccurenceId) async {
    // use getAnswersForUserAndEvent from event form repository
    final repository =
        EventFormsRepository(apiService: GraphQLClientSingleton());

    try {
      final answers = await repository.getAnswersForUserAndEvent(
        userId,
        eventOccurenceId,
      );

      _answers.clear();
      _oldAnswers.clear();

      _answers.addAll(answers);
      _oldAnswers.addAll(answers);
      notifyListeners();
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }
  }

  // mutate all the answers
  Future<bool> mutateAnswers() async {
    final repository =
        EventFormsRepository(apiService: GraphQLClientSingleton());

    try {
      await repository.identifyAnswerUpdates(_answers, _oldAnswers);
      return true;
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
      return false;
    }
  }

  // add answer to the list
  void addAnswer(AnswerModel answer) {
    print(
        "adding answer with multiple choice answers: ${answer.multipleChoiceAnswers}");
    _answers.add(answer);
    notifyListeners();
  }

  // get answers by question id
  AnswerModel? getAnswersByQuestionId(String questionId) {
    if (doesQuestionIdHaveAnswer(questionId)) {
      return _answers.firstWhere((element) => element.questionId == questionId);
    }

    return null;
  }

  // does question id have an answer
  bool doesQuestionIdHaveAnswer(String questionId) {
    return _answers.any((element) => element.questionId == questionId);
  }

  // update answer
  void updateAnswer(String questionId, AnswerModel answer) {
    final index =
        _answers.indexWhere((element) => element.questionId == questionId);
    _answers[index] = answer;
    notifyListeners();
  }

  // do all questions have answers
  bool doAllQuestionsHaveAnswers(List<String> questionIds) {
    return questionIds.every((element) => doesQuestionIdHaveAnswer(element));
  }
}
