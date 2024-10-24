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

      if (result.data != null &&
          result.data!["class_event_bookings"].length > 0) {
        try {
          return List<ClassEventBooking>.from(result
              .data!['class_event_bookings']
              .map((json) => ClassEventBooking.fromJson(json)));
        } catch (e) {
          throw Exception('Failed to parse class event bookings: $e');
        }
      } else {
        throw Exception('Failed to load class event bookings');
      }
    } catch (e) {
      throw Exception('Failed to load class event bookings: $e');
    }
  }
}
