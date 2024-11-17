import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/event_model.dart';
import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/types_and_extensions/event_type.dart';

class ClassModel {
  String? description;
  String? id;
  String? imageUrl;
  Location? location;
  String? locationName;
  String? name;
  String? requirements;
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
  List<ClassEvent>? classEvents;
  int? amountUpcomingEvents;
  List<RecurringPatternModel>? recurringPatterns;
  List<ClassOwner>? classOwner;
  // List<ClassTeachers>? invitedTeachers;

  // get the first teacher, that is the owner or if there is no owner, the first teacher
  ClassOwner? get owner {
    if (classOwner != null) {
      return classOwner!.firstWhere(
          (element) => element.isPaymentReceiver == true,
          orElse: () => classOwner!.first);
    }
    return null;
  }

  List<BookingOption> get bookingOptions {
    if (classBookingOptions != null) {
      return classBookingOptions!
          .where((e) => e.bookingOption != null)
          .map((e) => e.bookingOption!)
          .toList();
    }
    return [];
  }

  List<TeacherModel> get teachers {
    if (classTeachers != null) {
      return classTeachers!
          .where((e) => e.teacher != null)
          .map((e) => e.teacher!)
          .toList();
    }
    return [];
  }

  ClassModel(
      {this.bookingEmail,
      this.maxBookingSlots,
      this.classBookingOptions,
      this.description,
      this.id,
      this.urlSlug,
      this.imageUrl,
      this.location,
      this.locationName,
      this.name,
      this.isInitiallyFavorized,
      this.requirements,
      this.websiteUrl,
      this.classTeachers,
      this.distance,
      this.eventType,
      this.classEvents,
      this.city,
      this.country,
      this.isInitiallyFlagged,
      this.amountActiveFlaggs,
      this.amountNonActiveFlaggs,
      this.amountUpcomingEvents,
      this.classLevels});

  ClassModel.fromJson(Map<String, dynamic> json) {
    if (json["recurring_patterns"] != null) {
      recurringPatterns = <RecurringPatternModel>[];
      json["recurring_patterns"].forEach((v) {
        RecurringPatternModel newRecurrentPattern =
            RecurringPatternModel.fromJson(v);
        recurringPatterns!.add(newRecurrentPattern);
      });
    }
    if (json['class_events'] != null) {
      classEvents = <ClassEvent>[];
      json['class_events'].forEach((v) {
        ClassEvent newClassEvent = ClassEvent.fromJson(v);
        newClassEvent.classModel = this;
        classEvents!.add(newClassEvent);
      });
    }
    amountActiveFlaggs = json['class_flags']
            ?.where((flag) => flag['is_active'] == true)
            .length ??
        0;
    amountNonActiveFlaggs = json['class_flags']
            ?.where((flag) => flag['is_active'] == false)
            .length ??
        0;
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
    requirements = json['requirements'];
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
    if (json['class_owners'] != null) {
      classOwner = <ClassOwner>[];
      json['class_owners'].forEach((v) {
        classOwner!.add(ClassOwner.fromJson(v));
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

    if (json['class_events_aggregate']?['aggregate']?['count'] != null) {
      amountUpcomingEvents =
          json['class_events_aggregate']?['aggregate']?['count'] as int;
    }
  }
}
