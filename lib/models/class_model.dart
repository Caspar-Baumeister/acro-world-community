import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';

class ClassModel {
  String? classPassUrl;
  String? description;
  String? id;
  String? imageUrl;
  Location? location;
  String? locationName;
  String? name;
  String? pricing;
  String? requirements;
  String? uscUrl;
  String? websiteUrl;
  List<ClassTeachers>? classTeachers;
  List<ClassLevels>? classLevels;
  num? distance;
  String? bookingEmail;
  int? maxBookingSlots;
  List<ClassBookingOptions>? classBookingOptions;
  bool? isInitiallyFavorized;
  bool? isInitiallyFlagged;
  num? amountActiveFlaggs;
  num? amountNonActiveFlaggs;
  num? amountFavorits;
  EventType? eventType;
  String? city;
  String? country;
  String? urlSlug;

  // get the first teacher, that is the owner or if there is no owner, the first teacher
  ClassTeachers? get owner {
    if (classTeachers != null) {
      return classTeachers!.firstWhere((element) => element.isOwner == true,
          orElse: () => classTeachers!.first);
    }
    return null;
  }

  ClassModel(
      {this.bookingEmail,
      this.maxBookingSlots,
      this.classBookingOptions,
      this.classPassUrl,
      this.description,
      this.id,
      this.urlSlug,
      this.imageUrl,
      this.location,
      this.locationName,
      this.name,
      this.pricing,
      this.isInitiallyFavorized,
      this.requirements,
      this.uscUrl,
      this.websiteUrl,
      this.classTeachers,
      this.distance,
      this.eventType,
      this.city,
      this.country,
      this.isInitiallyFlagged,
      this.amountActiveFlaggs,
      this.amountNonActiveFlaggs,
      this.classLevels});

  ClassModel.fromJson(Map<String, dynamic> json) {
    amountActiveFlaggs = json['class_flags']
            ?.where((flag) => flag['is_active'] == true)
            .length ??
        0;
    amountNonActiveFlaggs = json['class_flags']
            ?.where((flag) => flag['is_active'] == false)
            .length ??
        0;
    classPassUrl = json['class_pass_url'];
    description = json['description'];
    distance = json['distance'];
    isInitiallyFavorized = json['class_favorits']?.isNotEmpty;
    isInitiallyFlagged = json['class_flags']?.isNotEmpty;

    id = json['id'];
    urlSlug = json['url_slug'];
    imageUrl = json['image_url'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['location_name'];
    name = json['name'];
    pricing = json['pricing'];
    requirements = json['requirements'];
    uscUrl = json['usc_url'];
    websiteUrl = json['website_url'];
    bookingEmail = json['booking_email'];
    maxBookingSlots = json['max_booking_slots'];
    city = json['location_city'];
    country = json['location_country'];
    if (json['class_booking_options'] != null) {
      classBookingOptions = <ClassBookingOptions>[];
      json['class_booking_options'].forEach((v) {
        classBookingOptions!.add(ClassBookingOptions.fromJson(v));
      });
    }
    if (json['class_teachers'] != null) {
      classTeachers = <ClassTeachers>[];
      json['class_teachers'].forEach((v) {
        classTeachers!.add(ClassTeachers.fromJson(v));
      });
    }
    if (json['class_levels'] != null) {
      classLevels = <ClassLevels>[];
      json['class_levels'].forEach((v) {
        classLevels!.add(ClassLevels.fromJson(v));
      });
    }

    eventType = json['event_type'] != null
        ? mapStringToEventType(json['event_type'])
        : null;
  }
}
