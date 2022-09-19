class ClassEvent {
  String classId;
  DateTime createdAt;
  DateTime endDate;
  String id;
  bool isCancelled;
  DateTime date;

  ClassEvent(
      {required this.classId,
      required this.createdAt,
      required this.endDate,
      required this.id,
      required this.isCancelled,
      required this.date});

  factory ClassEvent.fromJson(dynamic json) {
    return ClassEvent(
      classId: json['class_id'],
      createdAt: DateTime.parse(json["created_at"]),
      endDate: DateTime.parse(json["end_date"]),
      id: json["id"],
      isCancelled: json["is_cancelled"],
      date: DateTime.parse(json["start_date"]),
    );
  }
}
