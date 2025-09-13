import 'package:acroworld/data/graphql/input/booking_category_input.dart';
import 'package:acroworld/data/graphql/input/class_owner_input.dart';
import 'package:acroworld/data/graphql/input/class_teacher_input.dart';
import 'package:acroworld/data/graphql/input/question_input.dart';
import 'package:acroworld/data/graphql/input/recurring_patterns_input.dart';
import 'package:latlong2/latlong.dart';

class ClassUpsertInput {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String timezone;
  final String urlSlug;
  final bool isCashAllowed;
  final LatLng location;

  final int? maxBookingSlots;
  final String? locationName;
  final String? locationCity;
  final String? locationCountry;
  final String? eventType;

  final List<RecurringPatternInput> recurringPatterns;
  final List<ClassOwnerInput> classOwners;
  final List<ClassTeacherInput> classTeachers;
  final List<BookingCategoryInput> bookingCategories;
  final List<QuestionInput> questions;

  ClassUpsertInput({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.timezone,
    required this.urlSlug,
    required this.isCashAllowed,
    required this.location,
    required this.recurringPatterns,
    required this.classOwners,
    required this.classTeachers,
    required this.bookingCategories,
    required this.maxBookingSlots,
    required this.questions,
    this.eventType,
    this.locationName,
    this.locationCity,
    this.locationCountry,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image_url": imageUrl,
        "is_cash_allowed": isCashAllowed,
        "location_name": locationName,
        "location_city": locationCity,
        "location_country": locationCountry,
        "event_type": eventType,
        "timezone": timezone,
        "url_slug": urlSlug,
        "max_booking_slots": maxBookingSlots ?? 0,
        "location": {
          "type": "Point",
          "coordinates": [location.longitude, location.latitude]
        },
      };
}
