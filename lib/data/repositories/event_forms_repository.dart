import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
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

    print("questionresult $result");

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to create questions. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["insert_questions"] != null) {
      try {
        return result.data!['insert_questions']['affected_rows'];
      } catch (e) {
        throw Exception('Failed to parse class: $e');
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
      } catch (e) {
        throw Exception('Failed to parse class: $e');
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
    } catch (e) {
      throw Exception('Failed to parse in deleteQuestions: $e');
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
      } catch (e) {
        throw Exception('Failed to parse class: $e');
      }
    } else {
      throw Exception('Failed to delete class');
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
      } catch (e) {
        print('Error updating question with ID $id: $e');
        rethrow; // Optionally rethrow to stop on the first error
      }
    }
  }
}
