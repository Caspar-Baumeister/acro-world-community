import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/event/answer_model.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventFormsRepository {
  final GraphQLClientSingleton apiService;

  EventFormsRepository({required this.apiService});

  // creates questions for an event
  Future<dynamic> insertQuestions(List<Map<String, dynamic>> questions) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.insertQuestions,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"questions": questions},
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    print("insertQuestionResult $result");

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to create questions. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["insert_questions"] != null) {
      try {
        return result.data!['insert_questions']['affected_rows'];
      } catch (e, s) {
        throw Exception('Failed to parse class: $e \n  Stacktrace: $s');
      }
    } else {
      throw Exception('Failed to create class');
    }
  }

  // get all questions from an event
  Future<List<QuestionModel>> getQuestionsForEvent(String eventId) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getQuestionsForEvent,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"eventId": eventId},
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.query(queryOptions);

    print("questionresult $result");

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to get questions. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["questions"] != null) {
      try {
        List<QuestionModel> questions = [];
        for (var question in result.data!["questions"]) {
          questions.add(QuestionModel.fromJson(question));
        }
        return questions;
      } catch (e, s) {
        throw Exception('Failed to parse class: $e \n  Stacktrace: $s');
      }
    } else {
      throw Exception('Failed to get questions');
    }
  }

  //
  // get all questions from an event
  Future<List<QuestionModel>> getQuestionsForEventOccurence(
      String eventOccurenceId) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getQuestionsForEventOccurence,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"eventOccurenceId": eventOccurenceId},
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.query(queryOptions);

    print("questionresult $result");

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to get questions. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["questions"] != null) {
      try {
        List<QuestionModel> questions = [];
        for (var question in result.data!["questions"]) {
          questions.add(QuestionModel.fromJson(question));
        }
        return questions;
      } catch (e, s) {
        throw Exception('Failed to parse class: $e \n  Stacktrace: $s');
      }
    } else {
      throw Exception('Failed to get questions');
    }
  }

  // updateQuestions
  Future<dynamic> identifyQuestionUpdates(List<QuestionModel> newQuestions,
      List<QuestionModel> oldQuestions, String eventId) async {
    // then compare the questions and update the ones that are different
    List<QuestionModel> questionsToUpdate = [];
    List<QuestionModel> questionsToInsert = [];
    List<QuestionModel> questionsToDelete = [];
    // for all ids that are not in the new list, do a delete
    for (var oldQuestion in oldQuestions) {
      var newQuestion = newQuestions.firstWhere(
          (element) => element.id == oldQuestion.id,
          orElse: () => QuestionModel());

      if (newQuestion.id == null) {
        questionsToDelete.add(oldQuestion);
      }
    }

    // for all ids that do not exist, do an insert
    // for all ids that exist, do an update
    for (var newQuestion in newQuestions) {
      // find the question in the old list if it exists else insert
      var oldQuestion = oldQuestions.firstWhere(
          (element) => element.id == newQuestion.id,
          orElse: () => QuestionModel());

      if (newQuestion.eventId != null && newQuestion.position != null) {
        //go to next item in loop
        continue;
      }
      // do an insert for the new questions
      else if (oldQuestion.id == null) {
        questionsToInsert.add(newQuestion);
      } else {
        if (oldQuestion != newQuestion) {
          questionsToUpdate.add(newQuestion);
        }
      }
    }

    // do the inserts
    if (questionsToInsert.isNotEmpty) {
      await insertQuestions(questionsToInsert
          .map((e) => e.toJson(eventId, newQuestions.indexOf(e)))
          .toList());
    }

    // do the updates
    if (questionsToUpdate.isNotEmpty) {
      await updateQuestions(questionsToUpdate
          .map((e) => e.toJson(eventId, newQuestions.indexOf(e)))
          .toList());
    }

    // do the deletes
    if (questionsToDelete.isNotEmpty) {
      await deleteQuestions(questionsToDelete);
    }
  }

  // delete questions
  Future<dynamic> deleteQuestions(List<QuestionModel> questions) async {
    List<String> questionsMap = [];
    try {
      questionsMap = questions.map((e) => e.id!).toList();
    } catch (e, s) {
      throw Exception(
          'Failed to parse in deleteQuestions: $e \n Stacktrace: $s');
    }

    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.deleteQuestions,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"questionIds": questionsMap},
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to delete questions. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["delete_questions"] != null) {
      try {
        return result.data!['delete_questions']['affected_rows'];
      } catch (e, s) {
        throw Exception('Failed to parse class: $e \n  Stacktrace: $s');
      }
    } else {
      throw Exception('Failed to delete question');
    }
  }

// update questions using a loop with pk
  Future<void> updateQuestions(List<Map<String, dynamic>> questions) async {
    final graphQLClient = GraphQLClientSingleton().client;

    for (var question in questions) {
      final id = question["id"];
      if (id == null) {
        throw Exception('Question ID is required for update.');
      }

      MutationOptions mutationOptions = MutationOptions(
        document: Mutations.updateQuestionByPk,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "id": id,
          "updates": question,
        },
      );

      try {
        QueryResult<Object?> result =
            await graphQLClient.mutate(mutationOptions);

        if (result.hasException) {
          throw Exception(
              'Failed to update question with ID $id. Error: ${result.exception?.raw.toString()}');
        }

        if (result.data == null ||
            result.data!["update_questions_by_pk"] == null) {
          throw Exception('Failed to update question with ID $id.');
        }

        print('Updated Question ID: $id');
      } catch (e, s) {
        throw Exception(
            'Failed to update question with ID $id. Error: $e \n Stacktrace: $s');
      }
    }
  }

  /// Answers ///

  // get all answers for a user and event
  Future<List<AnswerModel>> getAnswersForUserAndEvent(
      String userId, String eventOccurenceId) async {
    QueryOptions options = QueryOptions(
      document: Queries.getAnswersOfUserAndEventOccurence,
      variables: {
        'user_id': userId,
        'event_occurence_id': eventOccurenceId,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;

    try {
      final result = await graphQLClient.query(options);

      if (result.hasException) {
        throw Exception(
            'Failed to get answers. Status code: ${result.exception?.raw.toString()}');
      }

      // create a list of AnswerModel from the result
      final List<AnswerModel> answers = (result.data!['answers'] as List)
          .map((e) => AnswerModel.fromJson(e))
          .toList();

      return answers;
    } catch (e, s) {
      throw Exception('Failed to get answers: $e \n Stacktrace: $s');
    }
  }

  // same as for questions, check for updates and insert or update
  Future<void> identifyAnswerUpdates(
      List<AnswerModel> newAnswers, List<AnswerModel> oldAnswers) async {
    // then compare the questions and update the ones that are different
    List<AnswerModel> answersToUpdate = [];
    List<AnswerModel> answersToInsert = [];
    List<AnswerModel> answersToDelete = [];
    // for all ids that are not in the new list, do a delete
    for (var oldAnswer in oldAnswers) {
      var newAnswer = newAnswers.firstWhere(
          (element) => element.id == oldAnswer.id,
          orElse: () => AnswerModel());

      if (newAnswer.id == null) {
        answersToDelete.add(oldAnswer);
      }
    }

    // for all ids that do not exist, do an insert
    // for all ids that exist, do an update
    for (var newAnswer in newAnswers) {
      // find the question in the old list if it exists else insert
      var oldAnswer = oldAnswers.firstWhere(
          (element) => element.id == newAnswer.id,
          orElse: () => AnswerModel());

      // do an insert for the new questions if no old answer exists with that id (or the id was null)
      if (oldAnswer.id == null) {
        answersToInsert.add(newAnswer);
      }
      // do an update if the old answer was found and is different from the new answer
      else if (oldAnswer != newAnswer) {
        answersToUpdate.add(newAnswer);
      }
    }

    // do the inserts
    if (answersToInsert.isNotEmpty) {
      await insertAnswers(answersToInsert.map((e) => e.toJson()).toList());
    }

    // do the updates
    if (answersToUpdate.isNotEmpty) {
      await updateAnswers(answersToUpdate.map((e) => e.toJson()).toList());
    }

    // do the deletes
    if (answersToDelete.isNotEmpty) {
      await deleteAnswers(answersToDelete);
    }
  }

  // insert answers
  Future<dynamic> insertAnswers(List<Map<String, dynamic>> answers) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.insertAnswers,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"answers": answers},
    );

    print("answers $answers");

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    print("answerresult $result");

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to create answers. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["insert_answers"] != null) {
      try {
        return result.data!['insert_answers']['affected_rows'];
      } catch (e, s) {
        throw Exception('Failed to parse class: $e \n  Stacktrace: $s');
      }
    } else {
      throw Exception('Failed to create class');
    }
  }

  // update answers
  Future<void> updateAnswers(List<Map<String, dynamic>> answers) async {
    final graphQLClient = GraphQLClientSingleton().client;

    for (var answer in answers) {
      final id = answer["id"];
      if (id == null) {
        throw Exception('Answer ID is required for update.');
      }

      print("update answer $answer");

      MutationOptions mutationOptions = MutationOptions(
        document: Mutations.updateAnswerByPk,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "id": id,
          "updates": answer,
        },
      );

      try {
        QueryResult<Object?> result =
            await graphQLClient.mutate(mutationOptions);

        if (result.hasException) {
          throw Exception(
              'Failed to update answer with ID $id. Error: ${result.exception?.raw.toString()}');
        }

        if (result.data == null ||
            result.data!["update_answers_by_pk"] == null) {
          throw Exception('Failed to update answer with ID $id.');
        }

        print('Updated Answer ID: $id');
      } catch (e, s) {
        throw Exception(
            'Failed to update answer with ID $id. Error: $e \n Stacktrace: $s');
      }
    }
  }

  // delete answers
  Future<dynamic> deleteAnswers(List<AnswerModel> answers) async {
    List<String> answersMap = [];

    answersMap = answers.map((e) => e.id!).toList();

    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.deleteAnswers,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"answerIds": answersMap},
    );

    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

      // Check for a valid response
      if (result.hasException) {
        throw Exception(
            'Failed to delete answers. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data != null && result.data!["delete_answers"] != null) {
        try {
          return result.data!['delete_answers']['affected_rows'];
        } catch (e, s) {
          throw Exception('Failed to parse class: $e \n  Stacktrace: $s');
        }
      } else {
        throw Exception('Failed to delete answer');
      }
    } catch (e, s) {
      throw Exception('Failed to delete answers: $e \n Stacktrace: $s');
    }
  }

  // get all questions and answers for a user and class event
  Future<Map<String, dynamic>> getQuestionsAndAnswersForUserAndClassEvent(
      {required String userId, required String classEventId}) async {
    // get all questions
    List<QuestionModel> questions =
        await getQuestionsForEventOccurence(classEventId).catchError((e) {
      throw Exception('Failed to get questions: $e');
    });

    // get all answers
    List<AnswerModel> answers =
        await getAnswersForUserAndEvent(userId, classEventId).catchError((e) {
      throw Exception('Failed to get answers: $e');
    });

    return {"questions": questions, "answers": answers};
  }
}
