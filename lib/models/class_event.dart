import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/teacher_model.dart';

class ClassEvent {
  String classId;
  DateTime createdAt;
  DateTime endDate;
  String id;
  bool isCancelled;
  DateTime date;
  int? countParticipants;
  ClassModel? classModel;
  List<TeacherLinkModel>? teacher;

  ClassEvent(
      {required this.classId,
      required this.createdAt,
      required this.endDate,
      required this.id,
      required this.isCancelled,
      this.countParticipants,
      this.classModel,
      this.teacher,
      required this.date});

  factory ClassEvent.fromJson(dynamic json,
      {ClassModel? classModel, List? teacherList}) {
    List<TeacherLinkModel> _teacher = [];
    if (teacherList != null && teacherList.isNotEmpty) {
      for (var t in teacherList) {
        _teacher.add(TeacherLinkModel.fromJson(t["teacher"]));
      }
    }
    return ClassEvent(
        classId: json['class_id'],
        createdAt: DateTime.parse(json["created_at"]),
        endDate: DateTime.parse(json["end_date"]),
        id: json["id"],
        countParticipants: json["participants_aggregate"]?["aggregate"]
            ?["count"],
        isCancelled: json["is_cancelled"],
        classModel: classModel,
        date: DateTime.parse(json["start_date"]),
        teacher: _teacher);
  }
}
