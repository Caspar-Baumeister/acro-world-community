class BookingOptionModel {
  String? id;
  String? title;
  String? subtitle;
  double? price;
  String? currency;
  bool? wasUpdated;
  bool? wasMarkedForDeletion;

  BookingOptionModel({
    this.id,
    this.title,
    this.subtitle,
    this.price,
    this.currency,
    this.wasUpdated,
    this.wasMarkedForDeletion,
  });

  // Factory method to create a BookingOptionModel from a map (e.g. from JSON)
  factory BookingOptionModel.fromMap(Map<String, dynamic> map) {
    return BookingOptionModel(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      price: map['price']?.toDouble(),
      currency: map['currency'],
      wasUpdated: map['wasUpdated'] ?? false,
      wasMarkedForDeletion: map['wasMarkedForDeletion'] ?? false,
    );
  }

  // Method to convert a BookingOptionModel to a map (e.g. for JSON encoding)
  Map<String, dynamic> toMap() {
    return {
      'booking_option': {
        'data': {
          'currency': currency,
          'price': price.toString(),
          'title': title,
          'subtitle': subtitle,
        }
      }
    };
  }
}
