import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';

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

  List<ClassEventBooking> get confirmedBookings =>
      _bookings.where((booking) => booking.status == "Confirmed").toList();
  // get total amount of bookings
  int get totalBookings => _totalBookings;

  CreatorBookingsProvider() {
    _loading = true;
    notifyListeners();
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
