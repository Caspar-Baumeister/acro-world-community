import 'package:acroworld/data/graphql/input/booking_category_input.dart';
import 'package:acroworld/data/graphql/input/class_owner_input.dart';
import 'package:acroworld/data/graphql/input/invite_input.dart';
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
  final List<BookingCategoryInput> bookingCategories;
  final List<QuestionInput> questions;
  final List<InviteInput> invites;

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
    required this.bookingCategories,
    required this.maxBookingSlots,
    required this.questions,
    required this.invites,
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
        "recurring_patterns": {
          "data": recurringPatterns.map((e) => e.toJson()).toList(),
          "on_conflict": {
            "constraint": "recurring_patterns_pkey",
            "update_columns": [
              "id",
              "class_id",
              "day_of_week",
              "start_date",
              "end_date",
              "start_time",
              "end_time",
              "recurring_every_x_weeks",
              "is_recurring"
            ]
          }
        },
        "class_owners": {
          "data": classOwners.map((e) => e.toJson()).toList(),
          "on_conflict": {
            "constraint": "class_owners_pkey",
            "update_columns": [
              "id",
              "class_id",
              "teacher_id",
              "is_payment_receiver"
            ]
          }
        },
        "booking_categories": {
          "data": bookingCategories.map((b) => b.toJson()).toList(),
          "on_conflict": {
            "constraint": "booking_category_pkey",
            "update_columns": [
              "id",
              "name",
              "class_id",
              "contingent",
              "description"
            ]
          }
        },
        "questions": {
          "data": questions.map((q) => q.toJson()).toList(),
          "on_conflict": {
            "constraint": "question_pkey",
            "update_columns": [
              "id",
              "allow_multiple_answers",
              "is_required",
              "position",
              "question",
              "question_type",
              "title",
              "event_id"
            ]
          }
        },
        "invites": {
          "data": invites.map((e) => e.toJson()).toList(),
          "on_conflict": {
            "constraint": "teacher_invites_pkey",
            "update_columns": [
              "id",
              "invited_user_id",
              "email",
              "entity",
            ]
          }
        },
      };
}
