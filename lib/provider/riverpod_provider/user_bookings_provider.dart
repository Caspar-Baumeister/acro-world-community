import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_bookings/user_bookings.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// State for user bookings
class UserBookingsState {
  final bool loading;
  final List<UserBookingModel> bookings;
  final String? error;
  final String searchQuery;
  final String selectedStatus;

  const UserBookingsState({
    this.loading = true,
    this.bookings = const [],
    this.error,
    this.searchQuery = "",
    this.selectedStatus = "all",
  });

  UserBookingsState copyWith({
    bool? loading,
    List<UserBookingModel>? bookings,
    String? error,
    String? searchQuery,
    String? selectedStatus,
  }) {
    return UserBookingsState(
      loading: loading ?? this.loading,
      bookings: bookings ?? this.bookings,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  List<UserBookingModel> get filteredBookings {
    List<UserBookingModel> filtered = bookings;

    // Filter by status (all, past, confirmed, waitingforpayment, cancelled)
    if (selectedStatus != "all") {
      if (selectedStatus == "past") {
        // Past means events that have already ended
        filtered = filtered
            .where((booking) => booking.endDate.isBefore(DateTime.now()))
            .toList();
      } else {
        filtered = filtered
            .where((booking) =>
                booking.status?.toLowerCase() == selectedStatus.toLowerCase())
            .toList();
      }
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((booking) {
        return booking.eventName
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ==
                true ||
            booking.locationName
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ==
                true ||
            booking.bookingTitle
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ==
                true;
      }).toList();
    }

    return filtered;
  }

  List<UserBookingModel> get futureBookings {
    return filteredBookings
        .where((booking) => booking.endDate.isAfter(DateTime.now()))
        .toList();
  }

  List<UserBookingModel> get pastBookings {
    return filteredBookings
        .where((booking) => booking.endDate.isBefore(DateTime.now()))
        .toList();
  }
}

/// Notifier for user bookings state management
class UserBookingsNotifier extends StateNotifier<UserBookingsState> {
  UserBookingsNotifier() : super(const UserBookingsState());

  /// Fetch user bookings
  Future<void> fetchBookings({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(loading: true, error: null);
    }

    try {
      final client = GraphQLClientSingleton().client;
      final result = await client.query(
        QueryOptions(
          document: Queries.userBookings,
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.logError(
            'Error fetching user bookings: ${result.exception}');
        state = state.copyWith(
          loading: false,
          error: result.exception.toString(),
        );
        return;
      }

      if (result.data?["me"] == null || result.data?["me"].isEmpty) {
        CustomErrorHandler.logDebug("No user data found");
        state = state.copyWith(
          loading: false,
          bookings: [],
        );
        return;
      }

      List<dynamic> bookingsData = result.data!["me"][0]["bookings"] ?? [];
      CustomErrorHandler.logDebug(
          "Fetched ${bookingsData.length} bookings from GraphQL");

      List<UserBookingModel> bookings = [];
      for (var bookingData in bookingsData) {
        try {
          final booking = UserBookingModel.fromJson(bookingData);
          bookings.add(booking);
          CustomErrorHandler.logDebug(
              "Successfully converted booking: ${booking.eventName}");
        } catch (e) {
          CustomErrorHandler.logError("Error converting booking: $e");
        }
      }

      CustomErrorHandler.logDebug(
          "Final counts - Future: ${state.futureBookings.length}, Past: ${state.pastBookings.length}, Total: ${bookings.length}");

      state = state.copyWith(
        loading: false,
        bookings: bookings,
      );
    } catch (e, stackTrace) {
      CustomErrorHandler.logError('Error in fetchBookings: $e',
          stackTrace: stackTrace);
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update selected status filter
  void updateSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }
}

/// Provider for user bookings state
final userBookingsProvider =
    StateNotifierProvider<UserBookingsNotifier, UserBookingsState>((ref) {
  return UserBookingsNotifier();
});
