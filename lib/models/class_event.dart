import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/models/user_model.dart';

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

class ClassTeachers {
  TeacherModel? teacher;
  bool? isOwner;

  ClassTeachers({this.teacher, this.isOwner});

  ClassTeachers.fromJson(Map<String, dynamic> json) {
    teacher =
        json['teacher'] != null ? TeacherModel.fromJson(json['teacher']) : null;
    isOwner = json['is_owner'];
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
