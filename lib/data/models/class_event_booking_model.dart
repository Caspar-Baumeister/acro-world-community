import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/utils/helper_functions/currency_formater.dart';

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
    String symbol;
    if (bookingOption?.currency.symbol != null) {
      symbol = bookingOption!.currency.symbol;
    } else {
      try {
        symbol = CurrencyDetail.getCurrencyDetail(currency).symbol;
      } catch (e) {
        symbol = currency;
      }
    }
    return "${(amount / 100).toStringAsFixed(2)}$symbol";
  }

  // implementing copyWith method only for changing the status
  ClassEventBooking copyWithStatus(String status) {
    return ClassEventBooking(
      id: id,
      user: user,
      classEvent: classEvent,
      bookingOption: bookingOption,
      amount: amount,
      status: status,
      currency: currency,
      paymentIntentId: paymentIntentId,
      createdAt: createdAt,
    );
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
