import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// State for creator bookings
class CreatorBookingsState {
  final bool loading;
  final bool isLoading;
  final List<ClassEventBooking> bookings;
  final int totalBookings;
  final int offset;
  final String? error;
  final String? creatorUserId;

  const CreatorBookingsState({
    this.loading = true,
    this.isLoading = false,
    this.bookings = const [],
    this.totalBookings = 0,
    this.offset = 0,
    this.error,
    this.creatorUserId,
  });

  CreatorBookingsState copyWith({
    bool? loading,
    bool? isLoading,
    List<ClassEventBooking>? bookings,
    int? totalBookings,
    int? offset,
    String? error,
    String? creatorUserId,
  }) {
    return CreatorBookingsState(
      loading: loading ?? this.loading,
      isLoading: isLoading ?? this.isLoading,
      bookings: bookings ?? this.bookings,
      totalBookings: totalBookings ?? this.totalBookings,
      offset: offset ?? this.offset,
      error: error ?? this.error,
      creatorUserId: creatorUserId ?? this.creatorUserId,
    );
  }

  bool get canFetchMore => bookings.length < totalBookings;

  List<ClassEventBooking> get confirmedBookings => bookings
      .where((booking) =>
          booking.status == "Confirmed" ||
          booking.status == "WaitingForPayment")
      .toList();
}

/// Notifier for creator bookings
class CreatorBookingsNotifier extends StateNotifier<CreatorBookingsState> {
  static const int _limit = 15;

  CreatorBookingsNotifier() : super(const CreatorBookingsState());

  /// Test constructor for unit tests
  CreatorBookingsNotifier.test() : super(const CreatorBookingsState());

  /// Confirm payment for a booking
  Future<bool> confirmPayment(String bookingId) async {
    try {
      final graphQLClientSingleton = GraphQLClientSingleton();
      final response = await graphQLClientSingleton.client.mutate(
        MutationOptions(
          document: Mutations.updateClassEventBooking,
          variables: {
            'id': bookingId,
            'booking': {"status": "Confirmed"}
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      CustomErrorHandler.logDebug("confirmPayment response: ${response.data}");

      if (response.hasException) {
        CustomErrorHandler.logError(
            'Error confirming payment: ${response.exception}');
        return false;
      }

      if (response.data != null) {
        // Update the booking status in the local state
        final updatedBookings = state.bookings.map((booking) {
          if (booking.id == bookingId) {
            return ClassEventBooking(
              id: booking.id,
              status: "Confirmed",
              user: booking.user,
              classEvent: booking.classEvent,
              bookingOption: booking.bookingOption,
              amount: booking.amount,
              currency: booking.currency,
              paymentIntentId: booking.paymentIntentId,
              createdAt: booking.createdAt,
              teacherEmail: booking.teacherEmail,
            );
          }
          return booking;
        }).toList();

        state = state.copyWith(bookings: updatedBookings);
        return true;
      }
      return false;
    } catch (e) {
      CustomErrorHandler.logError('Error confirming payment: $e');
      return false;
    }
  }

  /// Fetch bookings for the creator
  Future<void> fetchBookings({bool isRefresh = false}) async {
    if (state.creatorUserId == null) {
      CustomErrorHandler.logError('Creator user ID not set');
      return;
    }

    try {
      state = state.copyWith(
        loading: isRefresh ? false : true,
        isLoading: true,
        error: null,
      );

      final repository =
          BookingsRepository(apiService: GraphQLClientSingleton());
      final bookings = await repository.getCreatorsClassEventBookings(
        state.creatorUserId!,
        _limit,
        isRefresh ? 0 : state.offset,
      );

      if (isRefresh) {
        state = state.copyWith(
          bookings: bookings,
          offset: _limit,
          loading: false,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          bookings: [...state.bookings, ...bookings],
          offset: state.offset + _limit,
          loading: false,
          isLoading: false,
        );
      }
    } catch (e) {
      CustomErrorHandler.logError('Error fetching bookings: $e');
      state = state.copyWith(
        loading: false,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Fetch more bookings (pagination)
  Future<void> fetchMore() async {
    if (state.canFetchMore && !state.isLoading) {
      await fetchBookings();
    }
  }

  /// Get class event bookings aggregate
  Future<void> getClassEventBookingsAggregate() async {
    if (state.creatorUserId == null) {
      CustomErrorHandler.logError('Creator user ID not set');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final repository =
          BookingsRepository(apiService: GraphQLClientSingleton());
      final totalCount = await repository.getClassEventBookingsAggregate(
        state.creatorUserId!,
      );

      state = state.copyWith(
        totalBookings: totalCount,
        isLoading: false,
      );
    } catch (e) {
      CustomErrorHandler.logError('Error getting bookings aggregate: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Set creator user ID
  void setCreatorUserId(String userId) {
    state = state.copyWith(creatorUserId: userId);
  }

  /// Clear all data
  void clear() {
    state = const CreatorBookingsState();
  }
}

/// Provider for creator bookings
final creatorBookingsProvider =
    StateNotifierProvider<CreatorBookingsNotifier, CreatorBookingsState>(
  (ref) => CreatorBookingsNotifier(),
);
