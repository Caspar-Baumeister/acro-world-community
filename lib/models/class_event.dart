class ClassEvent {
  String classId;
  String createdAt;
  String endDate;
  String id;
  bool isCancelled;
  String startDate;

  ClassEvent(
      {required this.classId,
      required this.createdAt,
      required this.endDate,
      required this.id,
      required this.isCancelled,
      required this.startDate});

  factory ClassEvent.fromJson(dynamic json) {
    return ClassEvent(
      classId: json['class_id'],
      createdAt: json["created_at"],
      endDate: json["end_date"],
      id: json["id"],
      isCancelled: json["is_cancelled"],
      startDate: json["start_date"],
    );
  }
}
