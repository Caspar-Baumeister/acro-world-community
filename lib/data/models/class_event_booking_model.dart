import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/user_model.dart';

class ClassEventBooking {
  final String id;
  final User user;
  final ClassEvent classEvent;
  final BookingOption? bookingOption;
  final double amount;
  final String status;
  final String currency;
  final String? paymentIntentId;
  final DateTime createdAt;

  ClassEventBooking({
    required this.id,
    required this.user,
    required this.classEvent,
    required this.bookingOption,
    required this.amount,
    required this.status,
    required this.currency,
    required this.paymentIntentId,
    required this.createdAt,
  });

  String get bookingPriceString {
    return "${(amount / 100).toStringAsFixed(2)}${bookingOption?.currency.symbol ?? currency}";
  }

  factory ClassEventBooking.fromJson(Map<String, dynamic> json) {
    // TODO Bookingoptions should not be null in the future
    return ClassEventBooking(
      id: json['id'],
      user: User.fromJson(json['user']),
      classEvent: ClassEvent.fromJson(json['class_event']),
      bookingOption: json['booking_option'] != null
          ? BookingOption.fromJson(json['booking_option'])
          : null,
      amount: json['amount'].toDouble(),
      status: json['status'],
      currency: json['currency'],
      paymentIntentId: json['payment_intent_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
