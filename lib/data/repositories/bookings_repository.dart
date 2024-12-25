import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/utils/helper_functions/currency_formater.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BookingsRepository {
  final GraphQLClientSingleton apiService;

  BookingsRepository({required this.apiService});

// fetches all classeventbooking of a creator
  Future<List<ClassEventBooking>> getCreatorsClassEventBookings(
    String creatorId,
    int limit,
    int offset,
  ) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClassEventBookings,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "id": creatorId,
        "limit": limit,
        "offset": offset,
      },
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.query(queryOptions);

      // Check for a valid response
      if (result.hasException) {
        throw Exception(
            'Failed to load class event bookings. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data != null && result.data!["class_event_bookings"] != null) {
        try {
          return List<ClassEventBooking>.from(result
              .data!['class_event_bookings']
              .map((json) => ClassEventBooking.fromJson(json)));
        } catch (e, s) {
          throw Exception(
              'Error parsing ClassEventBooking: $e\nStackTrace: $s');
        }
      } else {
        throw Exception('Failed to load class event bookings: $result');
      }
    } catch (e) {
      throw Exception('Failed to load class event bookings: $e');
    }
  }

  //getClassEventBookingsAggregate
  Future<int> getClassEventBookingsAggregate(
    String creatorId,
  ) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClassEventBookingsAggregate,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "id": creatorId,
      },
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.query(queryOptions);

      // Check for a valid response
      if (result.hasException) {
        throw Exception(
            'Failed to load class event bookings. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data != null &&
          result.data!["class_event_bookings_aggregate"] != null) {
        try {
          return result.data!['class_event_bookings_aggregate']['aggregate']
              ['count'];
        } catch (e, s) {
          throw Exception(
              'Error parsing ClassEventBooking: $e\nStackTrace: $s');
        }
      } else {
        throw Exception('Failed to load class event bookings: $result');
      }
    } catch (e) {
      throw Exception('Failed to load class event bookings: $e');
    }
  }

  //fetches all classeventbookings of a creator with a specific class event id
  Future<List<ClassEventBooking>> getCreatorsClassEventBookingsByClassEvent(
    String creatorId,
    String classEventId,
  ) async {
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClassEventBookingsByClassEventId,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "created_by_id": creatorId,
        "class_event_id": classEventId,
      },
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.query(queryOptions);

      // Check for a valid response
      if (result.hasException) {
        print('GraphQL Exception: ${result.exception.toString()}');
        print('GraphQL Raw Exception: ${result.exception?.raw}');
        throw Exception(
            'Failed to load class event bookings. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data != null && result.data!["class_event_bookings"] != null) {
        try {
          return List<ClassEventBooking>.from(result
              .data!['class_event_bookings']
              .map((json) => ClassEventBooking.fromJson(json)));
        } catch (e, s) {
          throw Exception(
              'Error parsing ClassEventBooking: $e\nStackTrace: $s');
        }
      } else {
        throw Exception('Failed to load class event bookings: $result');
      }
    } catch (e, s) {
      throw Exception(
          'Failed to load class event bookings: $e\nStackTrace: $s');
    }
  }

  Future<bool> insertBookingOptions(
      List<Map<String, dynamic>> bookingOptions) async {
    final mutationOptions = MutationOptions(
      document: Mutations.insertBookingOptions,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'options': bookingOptions,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    final result = await graphQLClient.mutate(mutationOptions);

    if (result.hasException) {
      throw Exception(
        'Failed to insert booking options. '
        'Status code: ${result.exception?.raw.toString()}',
      );
    }

    if (result.data != null && result.data!["insert_booking_option"] != null) {
      return true;
    } else {
      throw Exception('Failed to insert booking options');
    }
  }

  Future<bool> updateBookingOption(Map<String, dynamic> variables) async {
    final mutationOptions = MutationOptions(
      document: Mutations.updateBookingOption,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "id": variables["id"],
        "option": {
          "commission": variables["option"]["commission"],
          "discount": variables["option"]["discount"],
          "price": variables["option"]["price"],
          "subtitle": variables["option"]["subtitle"],
          "title": variables["option"]["title"],
          "currency": variables["option"]["currency"],
          "category_id": variables["option"]["category_id"],
        },
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    final result = await graphQLClient.mutate(mutationOptions);

    if (result.hasException) {
      throw Exception(
        'Failed to update booking option. Status code: ${result.exception?.raw.toString()}',
      );
    }

    if (result.data != null &&
        result.data!["update_booking_option_by_pk"] != null) {
      return true;
    } else {
      throw Exception('Failed to update booking option');
    }
  }

  Future<bool> deleteBookingOption(String id) async {
    final mutationOptions = MutationOptions(
      document: Mutations.deleteBookingOption,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "id": id,
      },
    );

    final graphQLClient = GraphQLClientSingleton().client;
    final result = await graphQLClient.mutate(mutationOptions);

    if (result.hasException) {
      throw Exception(
        'Failed to delete booking option. Status code: ${result.exception?.raw.toString()}',
      );
    }

    if (result.data != null &&
        result.data!["delete_booking_option_by_pk"] != null) {
      return true;
    } else {
      throw Exception('Failed to delete booking option');
    }
  }

  Future<void> identifyBookingOptionUpdates(
    List<BookingOption> newOptions,
    List<BookingOption> oldOptions,
  ) async {
    List<BookingOption> optionsToInsert = [];
    List<BookingOption> optionsToUpdate = [];
    List<BookingOption> optionsToDelete = [];

    // 1. Identify options to DELETE
    //    (Options that exist in old but not in the new list)
    for (var oldOption in oldOptions) {
      final matchingNewOption = newOptions.firstWhere(
        (no) => no.id == oldOption.id,
        orElse: () => BookingOption(
          currency: CurrencyDetail.getCurrencyDetail(""),
        ),
      );

      // If we didn't find a matching option (id) in the new list, we need to delete it
      if (matchingNewOption.id == null) {
        optionsToDelete.add(oldOption);
      }
    }

    // 2. Identify options to INSERT or UPDATE
    for (var newOption in newOptions) {
      final matchingOldOption = oldOptions.firstWhere(
        (oo) => oo.id == newOption.id,
        orElse: () => BookingOption(
          currency: CurrencyDetail.getCurrencyDetail(""),
        ),
      );

      // If old option wasn't found, this is a new insert
      if (matchingOldOption.id == null) {
        optionsToInsert.add(newOption);
      } else {
        // If the option exists in both but is different, add to update list
        if (matchingOldOption != newOption) {
          optionsToUpdate.add(newOption);
        }
      }
    }

    // 3. Perform the operations

    // Insert
    if (optionsToInsert.isNotEmpty) {
      await insertBookingOptions(
        optionsToInsert.map((opt) => opt.toJson()).toList(),
      );
    }

    // Update
    if (optionsToUpdate.isNotEmpty) {
      for (var option in optionsToUpdate) {
        final optionJson = option.toJson();
        await updateBookingOption({
          "id": option.id,
          "option": optionJson,
        });
      }
    }

    // Delete
    if (optionsToDelete.isNotEmpty) {
      for (var option in optionsToDelete) {
        if (option.id != null) {
          await deleteBookingOption(option.id!);
        }
      }
    }
  }
}
