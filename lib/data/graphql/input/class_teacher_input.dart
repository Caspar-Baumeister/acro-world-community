class ClassTeacherInput {
  final String id;
  final String teacherId;
  final bool? hasAccepted;

  ClassTeacherInput({
    required this.id,
    required this.teacherId,
    this.hasAccepted,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
      };
}
