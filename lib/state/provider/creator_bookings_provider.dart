import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreatorBookingsProvider extends ChangeNotifier {
  bool _loading = true;
  final List<ClassEventBooking> _bookings = [];
  final int _limit = 15;
  int _offset = 0;
  int _totalBookings = 0;
  bool _isLoading = false;
  String? creatorUserId;

  bool get loading => _loading;
  bool get isLoading => _isLoading;
  bool get canFetchMore => _bookings.length < _totalBookings;

  List<ClassEventBooking> get confirmedBookings => _bookings
      .where((booking) =>
          booking.status == "Confirmed" ||
          booking.status == "WaitingForPayment")
      .toList();
  // get total amount of bookings
  int get totalBookings => _totalBookings;

  CreatorBookingsProvider() {
    _loading = true;
    notifyListeners();
  }

  //confirmPayment
  Future<bool> confirmPayment(String bookingId) async {
    GraphQLClientSingleton graphQLClientSingleton = GraphQLClientSingleton();
    try {
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
      print("confirmPayment response: ${response.data}");
      if (response.hasException) {
        CustomErrorHandler.captureException(response.exception.toString(),
            stackTrace: response.exception!.originalStackTrace);
        return false;
      }
      if (response.data == null ||
          response.data!["update_class_event_bookings_by_pk"] == null) {
        CustomErrorHandler.captureException(
            "No data found in confirmPayment response",
            stackTrace: StackTrace.current);
        return false;
      }
      // Update the booking in the local list
      final index = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWithStatus("Confirmed");
      }
      notifyListeners();
      return true;
    } catch (e, s) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: s);
      return false;
    }
  }

  // get the getClassEventBookingsAggregate
  Future<void> getClassEventBookingsAggregate() async {
    BookingsRepository bookingsRepository =
        BookingsRepository(apiService: GraphQLClientSingleton());
    if (creatorUserId == null) {
      return;
    }
    try {
      final int totalBookings = await bookingsRepository
          .getClassEventBookingsAggregate(creatorUserId!);
      _totalBookings = totalBookings;
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }
    notifyListeners();
  }

  Future<void> fetchMore() async {
    _isLoading = true;
    _offset += _limit;
    notifyListeners();
    await fetchBookings(isRefresh: false);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBookings({bool isRefresh = false}) async {
    BookingsRepository bookingsRepository =
        BookingsRepository(apiService: GraphQLClientSingleton());
    if (creatorUserId == null) {
      return;
    }
    if (isRefresh) {
      _offset = 0;
      _bookings.clear();
    }
    try {
      final List<ClassEventBooking> newBookings = await bookingsRepository
          .getCreatorsClassEventBookings(creatorUserId!, _limit, _offset);
      _bookings.addAll(newBookings);
    } catch (e, s) {
      CustomErrorHandler.captureException(e, stackTrace: s);
    }

    _loading = false;
    notifyListeners();
  }
}
