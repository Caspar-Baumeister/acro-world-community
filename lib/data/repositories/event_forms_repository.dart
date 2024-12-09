import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventFormsRepository {
  final GraphQLClientSingleton apiService;

  EventFormsRepository({required this.apiService});

  // creates questions for an event
  Future<dynamic> createQuestiosForEvent(
      List<Map<String, dynamic>> questions) async {
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

  // updateQuestions
  Future<dynamic> updateQuestions(List<Map<String, dynamic>> questions) async {
    // first get all the questions from the event

    // then compare the questions and update the ones that are different
    // for all ids that exist, do an update
    // for all ids that do not exist, do an insert
    // for all ids that are not in the new list, do a delete
  }
}
