import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/booking_category_model.dart';
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

    if (result.data != null && result.data!["classes"] != null) {
      try {
        classes = List<ClassModel>.from(
          result.data!['classes'].map((json) => ClassModel.fromJson(json)),
        );

        return {
          "classes": classes,
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
    print("urlSlug: ${variables["urlSlug"]}");
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.insertClassWithRecurringPatterns,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: variables,
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    // Check for a valid response
    if (result.hasException) {
      print("exeption result $result");
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

    if (result.data != null && result.data!["insert_classes_one"] != null) {
      try {
        return ClassModel.fromJson(result.data!['insert_classes_one']);
      } catch (e) {
        throw Exception('Failed to parse class: $e');
      }
    } else {
      throw Exception('Failed to update class ${result.data ?? result}');
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

  Future<bool> insertBookingCategories(
      List<Map<String, dynamic>> categories) async {
    print("categories: $categories");
    final mutationOptions = MutationOptions(
      document: Mutations.insertCategories,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'categories': categories,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    final result = await graphQLClient.mutate(mutationOptions);

    if (result.hasException) {
      throw Exception(
        'Failed to insert booking categories. '
        'Status code: ${result.exception?.raw.toString()}',
      );
    }

    if (result.data != null &&
        result.data!["insert_booking_category"] != null) {
      return true;
    } else {
      throw Exception('Failed to insert booking categories');
    }
  }

  // update booking category
  Future<bool> updateBookingCategory(Map<String, dynamic> variables) async {
    MutationOptions mutationOptions = MutationOptions(
        document: Mutations.updateCategory,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "id": variables["id"],
          "category": {
            "contingent": variables["category"]["contingent"],
            "name": variables["category"]["name"],
            "description": variables["category"]["description"],
          },
        });

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to update booking category. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null &&
        result.data!["update_booking_category_by_pk"] != null) {
      return true;
    } else {
      print("updateBookingCategory result: ${result.data}");
      throw Exception('Failed to update booking category');
    }
  }

  // delete booking category
  Future<bool> deleteBookingCategory(String id) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.deleteCategory,
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
          'Failed to delete booking category. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null &&
        result.data!["delete_booking_category_by_pk"] != null) {
      return true;
    } else {
      throw Exception('Failed to delete booking category ${result.data}');
    }
  }

  //getBookingCategoriesForEvent
  Future<List<BookingCategoryModel>> getBookingCategoriesForEvent(
      String eventId) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getBookingCategories,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "classId": eventId,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.query(queryOptions);

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to load booking categories. Status code: ${result.exception?.raw.toString()}');
    }

    List<BookingCategoryModel> bookingCategories = [];

    if (result.data != null && result.data!["booking_category"] != null) {
      try {
        bookingCategories = List<BookingCategoryModel>.from(
          result.data!['booking_category']
              .map((json) => BookingCategoryModel.fromJson(json)),
        );
        return bookingCategories;
      } catch (e) {
        throw Exception('Failed to parse booking categories: $e');
      }
    } else {
      throw Exception('Failed to load booking categories');
    }
  }

  // identifyCategoryUpdates
  Future<void> identifyBookingCategoryUpdates(
    List<BookingCategoryModel> newCategories,
    List<BookingCategoryModel> oldCategories,
    String eventId,
  ) async {
    // Lists to keep track of which categories need which operation
    List<BookingCategoryModel> categoriesToInsert = [];
    List<BookingCategoryModel> categoriesToUpdate = [];
    List<BookingCategoryModel> categoriesToDelete = [];

    // 1. Identify categories to DELETE
    //    (Categories that exist in old but not in the new list)
    for (var oldCategory in oldCategories) {
      var matchingNewCategory = newCategories.firstWhere(
        (nc) => nc.id == oldCategory.id,
        orElse: () => BookingCategoryModel.empty(), // or null in Dart <3.0
      );

      // If we didn't find a matching category (id) in the new list, we need to delete it
      if (matchingNewCategory.id == null) {
        categoriesToDelete.add(oldCategory);
      }
    }

    // 2. Identify categories to INSERT or UPDATE
    //    (Categories that exist in new but not in old => INSERT;
    //     Categories that exist in both but differ => UPDATE)
    for (var newCategory in newCategories) {
      var matchingOldCategory = oldCategories.firstWhere(
        (oc) => oc.id == newCategory.id,
        orElse: () => BookingCategoryModel.empty(), // or null in Dart <3.0
      );

      // If the old category wasn't found, this is a new insert
      if (matchingOldCategory.id == null) {
        categoriesToInsert.add(newCategory);
      } else {
        // If the category exists in both but is different, add to update list
        if (matchingOldCategory != newCategory) {
          categoriesToUpdate.add(newCategory);
        }
      }
    }

    // 3. Perform the operations
    //    Insert
    if (categoriesToInsert.isNotEmpty) {
      await insertBookingCategories(
        categoriesToInsert
            .map(
              (cat) => cat.toJson(eventId),
            )
            .toList(),
      );
    }

    //    Update
    if (categoriesToUpdate.isNotEmpty) {
      // You can either:
      // (1) do one-by-one update with `updateBookingCategory`
      // (2) create a bulk update mutation (like you did for questions)
      // Below does a loop, similar to how you did for questions:
      for (var category in categoriesToUpdate) {
        final categoryJson = category.toJson(eventId);
        await updateBookingCategory({
          "id": category.id,
          "category": categoryJson,
        });
      }
    }

    //    Delete
    if (categoriesToDelete.isNotEmpty) {
      for (var category in categoriesToDelete) {
        await deleteBookingCategory(category.id!);
      }
    }
  }

  // resolve all clas flags for a class
  Future<bool> resolveAllClassFlags(String classId) async {
    MutationOptions mutationOptions = MutationOptions(
      document: Mutations.resolveAllClassFlags,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "classId": classId,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    QueryResult<Object?> result = await graphQLClient.mutate(mutationOptions);

    print("classflags result: ${result.data}");

    // Check for a valid response
    if (result.hasException) {
      throw Exception(
          'Failed to resolve all class flags. Status code: ${result.exception?.raw.toString()}');
    }

    if (result.data != null && result.data!["update_class_flag"] != null) {
      return true;
    } else {
      throw Exception('Failed to resolve all class flags');
    }
  }
}
