import 'package:acroworld/data/models/booking_category_model.dart';
import 'package:acroworld/data/models/booking_option.dart';
import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/event/question_model.dart';
import 'package:acroworld/data/models/event_model.dart';
import 'package:acroworld/data/models/invitation_model.dart';
import 'package:acroworld/data/models/recurrent_pattern_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/models/user_model.dart';
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
  List<QuestionModel> questions = [];
  List<BookingCategoryModel>? bookingCategories;
  List<ClassFlagsModel>? classFlags;
  List<InvitationModel>? invites;
  bool? isCashAllowed;
  User? createdBy;

  // get the first teacher, that is the owner or if there is no owner, the first teacher
  ClassOwner? get owner {
    if (classOwner != null && classOwner!.isNotEmpty) {
      return classOwner!.firstWhere(
          (element) => element.isPaymentReceiver == true,
          orElse: () => classOwner!.first);
    }
    return null;
  }

  List<BookingOption> get bookingOptions {
    if (bookingCategories != null) {
      return bookingCategories!
          .expand((element) => element.bookingOptions ?? [])
          .cast<BookingOption>()
          .toList();
    }
    return [];
  }

  /// Determines if this class can accept bookings
  bool get isBookable {
    // Must have booking options
    if (bookingOptions.isEmpty) {
      return false;
    }

    // Must have payment capability (Stripe teacher OR cash payment allowed)
    final stripeId = owner?.teacher?.stripeId;
    final isStripeEnabled = owner?.teacher?.isStripeEnabled;
    final hasStripeTeacher = stripeId != null && isStripeEnabled == true;
    final allowsCash = isCashAllowed == true;

    return hasStripeTeacher || allowsCash;
  }

  bool flaggedByUser(String userId) {
    return classFlags?.any((element) =>
            element.userId == userId && element.isActive == true) ??
        false;
  }

  bool inActiveFlaggsByUser(String userId) {
    return classFlags?.any((element) =>
            element.userId == userId && element.isActive == false) ??
        true;
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
      this.description,
      this.id,
      this.urlSlug,
      this.imageUrl,
      this.location,
      this.locationName,
      this.name,
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
      this.classFlags,
      required this.questions,
      this.bookingCategories,
      this.isCashAllowed,
      this.createdBy,
      this.classLevels,
      this.invites});

  ClassModel.fromJson(Map<String, dynamic> json) {
    createdBy =
        json['created_by'] != null ? User.fromJson(json['created_by']) : null;

    if (json["recurring_patterns"] != null) {
      print(
          '🔍 CLASSMODEL DEBUG - Processing recurring_patterns, count: ${json["recurring_patterns"].length}');
      recurringPatterns = <RecurringPatternModel>[];
      json["recurring_patterns"].forEach((v) {
        print('🔍 CLASSMODEL DEBUG - Processing pattern: $v');
        RecurringPatternModel newRecurrentPattern =
            RecurringPatternModel.fromJson(v);
        recurringPatterns!.add(newRecurrentPattern);
        print(
            '🔍 CLASSMODEL DEBUG - Added pattern, total count: ${recurringPatterns!.length}');
      });
      print(
          '🔍 CLASSMODEL DEBUG - Final recurringPatterns count: ${recurringPatterns!.length}');
    }
    if (json['class_events'] != null) {
      classEvents = <ClassEvent>[];
      json['class_events'].forEach((v) {
        ClassEvent newClassEvent = ClassEvent.fromJson(v);
        newClassEvent.classModel = this;
        classEvents!.add(newClassEvent);
      });
    }

    questions = <QuestionModel>[];
    if (json['questions'] != null) {
      json['questions'].forEach(
        (v) {
          questions.add(QuestionModel.fromJson(v));
        },
      );
    }

    // print("this class ${json['name']} has ${json['class_flags']} flaggs");

    amountActiveFlaggs = json['class_flags']
            ?.where((flag) => flag['is_active'] == true)
            .length ??
        0;
    amountNonActiveFlaggs = json['class_flags']
            ?.where((flag) => flag['is_active'] == false)
            .length ??
        0;
    classFlags = <ClassFlagsModel>[];
    if (json['class_flags'] != null) {
      json['class_flags'].forEach((v) {
        classFlags!.add(ClassFlagsModel.fromJson(v));
      });
    }
    description = json['description'];
    distance = json['distance'];

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
    isCashAllowed = json['is_cash_allowed'] ?? false;
    country = json['location_country'];
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

    if (json['booking_categories'] != null) {
      bookingCategories = <BookingCategoryModel>[];
      json['booking_categories'].forEach((v) {
        bookingCategories!.add(BookingCategoryModel.fromJson(v));
      });
    }

    if (json['invites'] != null) {
      invites = [];
      json['invites'].forEach((invite) {
        final newInvite = InvitationModel.fromJson(invite);
        print('newInvite $newInvite');
        invites!.add(InvitationModel.fromJson(invite));
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

class ClassFlagsModel {
  String? id;
  bool? isActive;
  String? userId;

  ClassFlagsModel({this.id, this.isActive, this.userId});

  ClassFlagsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    userId = json['user_id'];
  }
}
