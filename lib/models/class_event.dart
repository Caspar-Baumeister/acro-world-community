import 'package:acroworld/models/class_model.dart';

class ClassEvent {
  String classId;
  DateTime createdAt;
  DateTime endDate;
  String id;
  bool isCancelled;
  DateTime date;
  int? countParticipants;
  ClassModel? classModel;

  ClassEvent(
      {required this.classId,
      required this.createdAt,
      required this.endDate,
      required this.id,
      required this.isCancelled,
      this.countParticipants,
      this.classModel,
      required this.date});

  factory ClassEvent.fromJson(dynamic json, {ClassModel? classModel}) {
    return ClassEvent(
      classId: json['class_id'],
      createdAt: DateTime.parse(json["created_at"]),
      endDate: DateTime.parse(json["end_date"]),
      id: json["id"],
      countParticipants: json["participants_aggregate"]?["aggregate"]?["count"],
      isCancelled: json["is_cancelled"],
      classModel: classModel,
      date: DateTime.parse(json["start_date"]),
    );
  }
}
