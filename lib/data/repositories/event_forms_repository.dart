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

  Future<void> insertQuestionsWithOptions(
      List<QuestionModel> questions, String eventId) async {
    final client = GraphQLClientSingleton().client;

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final questionJson = q.toJson(eventId, i);

      // Insert single question
      final questionResult = await client.mutate(MutationOptions(
        document: Mutations.insertSingleQuestion,
        variables: {"question": questionJson},
      ));

      if (questionResult.hasException) {
        throw Exception(
            "Failed to insert question: ${questionResult.exception.toString()}");
      }

      final questionId = questionResult.data?["insert_questions_one"]["id"];
      if (questionId == null) throw Exception("No question ID returned");

      // If it's a multiple choice question, insert its options
      if (q.type == QuestionType.multipleChoice &&
          q.choices != null &&
          q.choices!.isNotEmpty) {
        final options = q.choices!.asMap().entries.map((entry) {
          return {
            "question_id": questionId,
            "option_text": entry.value.optionText,
            "position": entry.key,
          };
        }).toList();

        final optionsResult = await client.mutate(MutationOptions(
          document: Mutations.insertMultipleChoiceOptions,
          variables: {"options": options},
        ));

        if (optionsResult.hasException) {
          throw Exception(
              "Failed to insert options: ${optionsResult.exception.toString()}");
        }
      }
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
      await insertQuestionsWithOptions(questionsToInsert, eventId);
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

      print("result.data ${result.data}");

      // create a list of AnswerModel from the result
      final List<AnswerModel> answers = (result.data!['answers'] as List)
          .map((e) => AnswerModel.fromJson(e))
          .toList();

      return answers;
    } catch (e, s) {
      throw Exception('Failed to get answers: $e \n Stacktrace: $s');
    }
  }

  Future<void> identifyAnswerUpdates(
      List<AnswerModel> newAnswers, List<AnswerModel> oldAnswers) async {
    final List<AnswerModel> answersToUpdate = [];
    final List<AnswerModel> answersToInsert = [];
    final List<AnswerModel> answersToDelete = [];

    // Step 1: find deletions
    for (var oldAnswer in oldAnswers) {
      var newAnswer = newAnswers.firstWhere(
          (element) => element.id == oldAnswer.id,
          orElse: () => AnswerModel());

      if (newAnswer.id == null) {
        answersToDelete.add(oldAnswer);
      }
    }

    // Step 2: find inserts and updates
    for (var newAnswer in newAnswers) {
      var oldAnswer = oldAnswers.firstWhere(
          (element) => element.id == newAnswer.id,
          orElse: () => AnswerModel());

      if (oldAnswer.id == null) {
        answersToInsert.add(newAnswer);
      } else if (oldAnswer != newAnswer) {
        answersToUpdate.add(newAnswer);
      }
    }

    // Step 3: Insert and store returned IDs
    if (answersToInsert.isNotEmpty) {
      final insertedAnswerResults = await insertAnswersReturnIds(
          answersToInsert.map((e) => e.toJson()).toList());

      for (int i = 0; i < insertedAnswerResults.length; i++) {
        final answerId = insertedAnswerResults[i]["id"];
        answersToInsert[i].id = answerId;
      }
    }

    // Step 4: Insert Multiple Choice Option answers (for new or updated answers)
    final List<MultipleChoiceAnswerModel> newMCAs = [];
    for (final a in [...answersToInsert, ...answersToUpdate]) {
      if (a.multipleChoiceAnswers == null) continue;

      for (final mca in a.multipleChoiceAnswers!) {
        mca.answerId ??= a.id;
        newMCAs.add(mca);
      }
    }

    print("newMCAs lenght ${newMCAs.length}");

    if (newMCAs.isNotEmpty) {
      await insertMultipleChoiceAnswers(
          newMCAs.map((e) => e.toJson()).toList());
    }

    // Step 5: Delete Multiple Choice options removed from updated answers
    for (final updated in answersToUpdate) {
      final old = oldAnswers.firstWhere((e) => e.id == updated.id);

      final oldOptionIds =
          old.multipleChoiceAnswers?.map((e) => e.id!).toSet() ?? {};
      final newOptionIds =
          updated.multipleChoiceAnswers?.map((e) => e.id!).toSet() ?? {};

      final removed = oldOptionIds.difference(newOptionIds);

      if (removed.isNotEmpty) {
        await deleteMultipleChoiceAnswersByOptionIds(
            optionIds: removed.toList());
      }
    }

    // Step 6: Update textual answers
    if (answersToUpdate.isNotEmpty) {
      await updateAnswers(answersToUpdate.map((e) => e.toJson()).toList());
    }

    // Step 7: Delete full answers
    if (answersToDelete.isNotEmpty) {
      await deleteAnswers(answersToDelete);
    }
  }

  // delete multiple choice answers by option ids one by one trough deleteMultipleChoiceAnswerByPk
  Future<void> deleteMultipleChoiceAnswersByOptionIds(
      {required List<String> optionIds}) async {
    final graphQLClient = GraphQLClientSingleton().client;

    for (final optionId in optionIds) {
      final options = {
        "id": optionId,
      };

      final mutationOptions = MutationOptions(
        document: Mutations.deleteMultipleChoiceAnswerByPk,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: options,
      );

      final result = await graphQLClient.mutate(mutationOptions);

      if (result.hasException) {
        throw Exception(
            'Failed to delete multiple choice answer. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data == null ||
          result.data!["delete_multiple_choice_answer_by_pk"] == null) {
        throw Exception('Failed to delete multiple choice answer');
      }
    }
  }

  // insert multiple choice answers
  Future<void> insertMultipleChoiceAnswers(
      List<Map<String, dynamic>> multipleChoiceAnswers) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.insertMultipleChoiceAnswers,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"answers": multipleChoiceAnswers},
    );

    print("answers $multipleChoiceAnswers");
    final graphQLClient = GraphQLClientSingleton().client;

    try {
      QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

      print("insertMultipleChoiceAnswers result $result");

      // Check for a valid response
      if (result.hasException) {
        throw Exception(
            'Failed to create multiple choice answers. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data != null &&
          result.data!["insert_multiple_choice_answer"] != null) {
        try {
          return result.data!['insert_multiple_choice_answer']['affected_rows'];
        } catch (e, s) {
          throw Exception('Failed to parse class: $e \n  Stacktrace: $s');
        }
      } else {
        throw Exception('Failed to create multiple choice answers');
      }
    } catch (e, s) {
      throw Exception(
          'Failed to create multiple choice answers: $e \n Stacktrace: $s');
    }
  }

  // insert answers
  Future<dynamic> insertAnswersReturnIds(
      List<Map<String, dynamic>> answers) async {
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
        print(
            "result.data!['insert_answers']!['returning'] ${result.data!['insert_answers']!['returning']} with type: ${result.data!['insert_answers']!['returning'].runtimeType}");
        return result.data!['insert_answers']!['returning'] as List<dynamic>;
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
