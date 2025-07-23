import 'package:acroworld/data/models/booking_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This provider holds the ID of the selected booking option.
/// Initially it's `null` until the user selects an option.
final selectedBookingOptionIdProvider =
    StateProvider<BookingOption?>((ref) => null);
