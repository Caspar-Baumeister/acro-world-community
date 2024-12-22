import 'package:acroworld/utils/helper_functions/currency_formater.dart';

class ClassBookingOptions {
  BookingOption? bookingOption;

  ClassBookingOptions({this.bookingOption});

  ClassBookingOptions.fromJson(Map<String, dynamic> json) {
    bookingOption = json['booking_option'] != null
        ? BookingOption.fromJson(json['booking_option'])
        : null;
  }
}

class BookingOption {
  num? commission;
  num? discount;
  String? id;
  num? price;
  String? subtitle;
  String? title;
  CurrencyDetail currency = CurrencyDetail.getCurrencyDetail("");
  bool? wasUpdated;
  bool? wasMarkedForDeletion;
  String? bookingCategoryId;

  double realPriceDiscounted() {
    return (1 - (discount! * 0.01)) * price! * 0.01;
  }

  double originalPrice() {
    return price! * 0.01;
  }

  BookingOption({
    this.commission,
    this.discount,
    this.id,
    this.price,
    this.subtitle,
    required this.currency,
    this.title,
    this.wasUpdated,
    this.wasMarkedForDeletion,
    this.bookingCategoryId,
  });

  BookingOption.fromJson(Map<String, dynamic> json) {
    commission = json['commission'];
    discount = json['discount'];
    id = json['id'];
    price = json['price'];
    subtitle = json['subtitle'];
    title = json['title'];
    if (json['currency'] != null) {
      currency = CurrencyDetail.getCurrencyDetail(json['currency']);
    }
    wasUpdated = json['wasUpdated'] ?? false;
    wasMarkedForDeletion = json['wasMarkedForDeletion'] ?? false;
    bookingCategoryId = json['category_id'];
  }

  // Method to convert a BookingOptionModel to a map (e.g. for JSON encoding)
  Map<String, dynamic> toMap() {
    return {
      'booking_option': {
        'data': {
          'currency': currency.value,
          'price': price.toString(),
          'title': title,
          'subtitle': subtitle,
          'category_id': bookingCategoryId,
        }
      }
    };
  }
}
