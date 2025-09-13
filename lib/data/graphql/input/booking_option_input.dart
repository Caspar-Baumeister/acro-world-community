class BookingOptionInput {
  final String id;
  final String title;
  final String subtitle;
  final num price;
  final num discount;
  final String currency;

  BookingOptionInput({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.discount,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "price": price,
        "discount": discount,
        "currency": currency,
      };
}
