import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClassesRepository {
  final GraphQLClientSingleton apiService;

  ClassesRepository({required this.apiService});

// Fetches class with full information
  Future<ClassModel> getClassBySlug(String slug) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClassBySlugWithOutFavorite,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "url_slug": slug,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.query(queryOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to load class. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["classes"].length > 0) {
      try {
        return ClassModel.fromJson(result.data!['classes'][0]);
      } catch (e) {
        throw Exception('Failed to parse class: $e');
      }
    } else {
      throw Exception('Failed to load class, no data, with result $result');
    }
  }

  // Fetches classes with teacher privileges for displaying list of classes
  Future<Map<String, dynamic>> getClassesLazyAsTeacher(
      int limit, int offset, Map where) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClassesLazyAsTeacherUser,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "limit": limit,
        "offset": offset,
        "where": where,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.query(queryOptions);

    // Check for a valid response
    if (result.hasException == true) {
      throw Exception(
          'Failed to load classes. result: ${result.exception?.raw ?? result}');
    }

    List<ClassModel> classes = [];
    int? totalClasses;

    if (result.data != null && result.data!["classes"] != null) {
      try {
        classes = List<ClassModel>.from(
          result.data!['classes'].map((json) => ClassModel.fromJson(json)),
        );
        totalClasses = result.data!["classes_aggregate"]["aggregate"]["count"];

        return {
          "classes": classes,
          "totalClasses": totalClasses,
        };
      } catch (e) {
        throw Exception('Failed to parse classes: $e');
      }
    } else {
      throw Exception('Failed to load classes, no data, with result $result');
    }
  }

  // creates a new class
  Future<ClassModel> createClass(Map<String, dynamic> variables) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.insertClassWithRecurringPatterns,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: variables,
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to create class. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["insert_classes_one"] != null) {
      try {
        return ClassModel.fromJson(result.data!['insert_classes_one']);
      } catch (e) {
        throw Exception('Failed to parse class: $e');
      }
    } else {
      throw Exception('Failed to create class');
    }
  }

  // updates a class
  Future<ClassModel> updateClass(Map<String, dynamic> variables) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.updateClassWithRecurringPatterns,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: variables,
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to update class. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["update_classes_by_pk"] != null) {
      try {
        return ClassModel.fromJson(result.data!['update_classes_by_pk']);
      } catch (e) {
        throw Exception('Failed to parse class: $e');
      }
    } else {
      throw Exception('Failed to update class');
    }
  }

  // delete class
  Future<bool> deleteClass(String id) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.deleteClassById,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "id": id,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'result has Exaption: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["delete_classes_by_pk"] != null) {
      return true;
    } else {
      throw Exception(
          'result data delete_classes_by_pk is null ${result.data}');
    }
  }

  //getUpcomingClassEventsById
  Future<List<ClassEvent>> getUpcomingClassEventsById(
      String classId, bool showPastEvents) async {
    QueryOptions queryOptions = QueryOptions(
      document: showPastEvents
          ? Queries.getClassEventsById
          : Queries.getUpcomingClassEventsById,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "classId": classId,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.query(queryOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to load class events. Status code: ${result.exception?.raw.toString()}');
    }

    List<ClassEvent> classEvents = [];

    if (result.data != null && result.data!["class_events"] != null) {
      try {
        classEvents = List<ClassEvent>.from(
          result.data!['class_events'].map((json) => ClassEvent.fromJson(json)),
        );
        return classEvents;
      } catch (e) {
        throw Exception('Failed to parse class events: $e');
      }
    } else {
      throw Exception('Failed to load class events');
    }
  }

  // cancel class event
  Future<bool> cancelClassEvent(String id) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.cancelClassEvent,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "id": id,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to cancel class event. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null &&
        result.data!["update_class_events_by_pk"] != null) {
      return true;
    } else {
      throw Exception('Failed to cancel class event');
    }
  }
}
