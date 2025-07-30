import 'package:acroworld/data/graphql/input/booking_option_input.dart';

class BookingCategoryInput {
  final String id;
  final String name;
  final int contingent;
  final String description;
  final List<BookingOptionInput> bookingOptions;

  BookingCategoryInput({
    required this.id,
    required this.name,
    required this.contingent,
    required this.description,
    required this.bookingOptions,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contingent": contingent,
        "description": description,
        "booking_options": {
          "data": bookingOptions.map((e) => e.toJson()).toList(),
          "on_conflict": {
            "constraint": "booking_option_pkey",
            "update_columns": [
              "id",
              "title",
              "subtitle",
              "price",
              "discount",
              "currency"
            ]
          }
        }
      };
}
