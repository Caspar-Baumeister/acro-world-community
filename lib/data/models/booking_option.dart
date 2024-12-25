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

  BookingOption({
    this.commission,
    this.discount,
    this.id,
    this.price,
    this.subtitle,
    required this.currency,
    this.title,
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
    bookingCategoryId = json['category_id'];
  }

  /// Converts a [BookingOption] into the JSON map needed by your GraphQL mutation
  Map<String, dynamic> toJson() {
    print("object: ${toString()}");
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
}
