import 'package:acroworld/data/models/class_event_booking_model.dart';
import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter/material.dart';

class CreatorBookingsProvider extends ChangeNotifier {
  bool _loading = true;
  final List<ClassEventBooking> _bookings = [];
  final int _limit = 3;
  int _offset = 0;
  final int _totalBookings = 0;
  bool _isLoading = false;
  String? creatorId;

  bool get loading => _loading;
  List<ClassEventBooking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  bool get canFetchMore => _bookings.length < _totalBookings;

  CreatorBookingsProvider() {
    _loading = true;
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
    if (creatorId == null) {
      return;
    }
    if (isRefresh) {
      _offset = 0;
      _bookings.clear();
    }
    try {
      final List<ClassEventBooking> newBookings = await bookingsRepository
          .getCreatorsClassEventBookings(creatorId!, _limit, _offset);
      _bookings.addAll(newBookings);
    } catch (e) {}

    _loading = false;
    notifyListeners();
  }
}
