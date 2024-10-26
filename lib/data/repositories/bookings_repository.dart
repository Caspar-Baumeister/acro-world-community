import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/services/gql_client_service.dart';
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
    // TODO add limit and offset
    QueryOptions queryOptions = QueryOptions(
      document: Queries.getClassEventBookings,
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "id": creatorId,
      },
    );
    try {
      final graphQLClient = GraphQLClientSingleton().client;
      QueryResult<Object?> result = await graphQLClient.query(queryOptions);
      print("id: $creatorId");

      // Check for a valid response
      if (result.hasException) {
        throw Exception(
            'Failed to load class event bookings. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data != null &&
          result.data!["class_event_bookings"].length > 0) {
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
        throw Exception(
            'Failed to load class event bookings. Status code: ${result.exception?.raw.toString()}');
      }

      if (result.data != null &&
          result.data!["class_event_bookings"].length > 0) {
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
}
