import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/user_model.dart';

class ClassEventBooking {
  final String id;
  final User user;
  final ClassEvent classEvent;
  final BookingOption bookingOption;
  final int amount;
  final String status;
  final String currency;
  final String paymentIntentId;

  ClassEventBooking({
    required this.id,
    required this.user,
    required this.classEvent,
    required this.bookingOption,
    required this.amount,
    required this.status,
    required this.currency,
    required this.paymentIntentId,
  });

  factory ClassEventBooking.fromJson(Map<String, dynamic> json) {
    return ClassEventBooking(
      id: json['id'],
      user: User.fromJson(json['user']),
      classEvent: ClassEvent.fromJson(json['class_event']),
      bookingOption: BookingOption.fromJson(json['booking_option']),
      amount: json['amount'],
      status: json['status'],
      currency: json['currency'],
      paymentIntentId: json['payment_intent_id'],
    );
  }
}
