import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/data/models/user_model.dart';

enum ClassEventBookingStatus { notEnabled, openSlots, full, empty, canceled }

class ClassEvent {
  String? classId;
  String? createdAt;
  String? endDate;
  String? id;
  bool? isCancelled;
  String? startDate;
  ParticipantsAggregate? participantsAggregate;
  List<User>? participants;
  ClassModel? classModel;
  num? availableBookingSlots;
  num? maxBookingSlots;
  RecurringPattern? recurringPattern;
  bool? isHighlighted;

  DateTime get startDateDT => DateTime.parse(startDate!);
  get endDateDT => endDate != null ? DateTime.parse(endDate!) : null;

  /// Determines if this event can accept bookings
  bool get isBookable {
    // Must have booking slots configured
    if (maxBookingSlots == null || availableBookingSlots == null) {
      return false;
    }

    // Must have available slots
    if (availableBookingSlots! <= 0) {
      return false;
    }

    // Must have a class model that is bookable
    if (classModel == null) {
      return false;
    }

    return classModel!.isBookable;
  }

  ClassEventBookingStatus get bookingStatus {
    if (isCancelled!) {
      return ClassEventBookingStatus.canceled;
    }
    if (maxBookingSlots == 0) {
      return ClassEventBookingStatus.notEnabled;
    }
    if (availableBookingSlots == 0) {
      return ClassEventBookingStatus.full;
    }
    if (availableBookingSlots == maxBookingSlots) {
      return ClassEventBookingStatus.empty;
    }
    return ClassEventBookingStatus.openSlots;
  }

  ClassEvent(
      {this.classId,
      this.createdAt,
      this.endDate,
      this.id,
      this.isCancelled,
      this.startDate,
      this.participantsAggregate,
      this.participants,
      this.maxBookingSlots,
      this.availableBookingSlots,
      this.recurringPattern,
      this.isHighlighted,
      this.classModel});

  ClassEvent.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    createdAt = json['created_at'];
    endDate = json['end_date'];
    isHighlighted = json['is_highlighted'];
    id = json['id'];
    availableBookingSlots = json['available_booking_slots'];
    maxBookingSlots = json['max_booking_slots'];

    isCancelled = json['is_cancelled'];
    startDate = json['start_date'];
    participantsAggregate = json['participants_aggregate'] != null
        ? ParticipantsAggregate.fromJson(json['participants_aggregate'])
        : null;
    if (json['participants'] != null) {
      participants = <User>[];
      json['participants'].forEach((v) {
        participants!.add(User.fromJson(v));
      });
    }
    classModel =
        json['class'] != null ? ClassModel.fromJson(json['class']) : null;

    recurringPattern = json['recurring_pattern'] != null
        ? RecurringPattern.fromJson(json['recurring_pattern'])
        : null;
  }
}

class RecurringPattern {
  bool? isRecurring;
  String? id;
  String? startDate;
  String? endDate;

  RecurringPattern({this.isRecurring, this.id, this.startDate, this.endDate});

  RecurringPattern.fromJson(Map<String, dynamic> json) {
    isRecurring = json['is_recurring'];
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_recurring'] = isRecurring;
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}

class ParticipantsAggregate {
  Aggregate? aggregate;

  ParticipantsAggregate({this.aggregate});

  ParticipantsAggregate.fromJson(Map<String, dynamic> json) {
    aggregate = json['aggregate'] != null
        ? Aggregate.fromJson(json['aggregate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (aggregate != null) {
      data['aggregate'] = aggregate!.toJson();
    }
    return data;
  }
}

class Aggregate {
  int? count;

  Aggregate({this.count});

  Aggregate.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

class ClassOwner {
  TeacherModel? teacher;
  bool? isPaymentReceiver;

  ClassOwner({this.teacher, this.isPaymentReceiver});

  ClassOwner.fromJson(Map<String, dynamic> json) {
    teacher =
        json['teacher'] != null ? TeacherModel.fromJson(json['teacher']) : null;
    isPaymentReceiver = json['is_payment_receiver'];
  }
}

class ClassTeachers {
  TeacherModel? teacher;
  bool? isOwner;
  bool? hasAccepted;
  ClassModel? classModel;

  ClassTeachers(
      {this.teacher, this.isOwner, this.hasAccepted, this.classModel});

  ClassTeachers.fromJson(Map<String, dynamic> json) {
    teacher =
        json['teacher'] != null ? TeacherModel.fromJson(json['teacher']) : null;
    isOwner = json['is_owner'];
    hasAccepted = json['has_accepted'];
    classModel =
        json['class'] != null ? ClassModel.fromJson(json['class']) : null;
  }
}

class ClassLevels {
  Level? level;

  ClassLevels({this.level});

  ClassLevels.fromJson(Map<String, dynamic> json) {
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (level != null) {
      data['level'] = level!.toJson();
    }
    return data;
  }
}

class Level {
  String? name;
  String? id;

  Level({this.name, this.id});

  Level.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
