import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/utils/helper_functions/currency_formater.dart';

class BookingOption {
  num? commission;
  num? discount;
  String? id;
  num? price;
  String? subtitle;
  String? title;
  CurrencyDetail currency = CurrencyDetail.getCurrencyDetail("");
  String? bookingCategoryId;
  BookingCategoryModel? bookingCategory;

  BookingOption({
    this.commission,
    this.discount,
    this.id,
    this.price,
    this.subtitle,
    required this.currency,
    this.title,
    this.bookingCategoryId,
    this.bookingCategory,
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
    bookingCategoryId = json['category_id'];
    if (json['category'] != null) {
      bookingCategory = BookingCategoryModel.fromJson(json['category']);
    }
  }

  /// Converts a [BookingOption] into the JSON map needed by your GraphQL mutation
  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'subtitle': subtitle,
      'title': title,
      'currency': currency.value,
      'category_id': bookingCategoryId,
    };
  }

  double realPriceDiscounted() {
    return (1 - (discount! * 0.01)) * price! * 0.01;
  }

  double originalPrice() {
    return price! * 0.01;
  }

  // tostring
  @override
  String toString() {
    return 'BookingOption{id: $id, price: $price, subtitle: $subtitle, title: $title, currency: $currency, bookingCategoryId: $bookingCategoryId}';
  }

  // equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingOption &&
        other.price == price &&
        other.subtitle == subtitle &&
        other.title == title &&
        other.currency == currency &&
        other.bookingCategoryId == bookingCategoryId;
  }
}
