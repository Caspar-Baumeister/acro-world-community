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

  get date => startDate != null ? DateTime.parse(startDate!) : null;

  ClassEvent(
      {this.classId,
      this.createdAt,
      this.endDate,
      this.id,
      this.isCancelled,
      this.startDate,
      this.participantsAggregate,
      this.participants,
      this.classModel});

  ClassEvent.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    createdAt = json['created_at'];
    endDate = json['end_date'];
    id = json['id'];
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

  ClassTeachers({this.teacher});

  ClassTeachers.fromJson(Map<String, dynamic> json) {
    teacher =
        json['teacher'] != null ? TeacherModel.fromJson(json['teacher']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    }
    return data;
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
