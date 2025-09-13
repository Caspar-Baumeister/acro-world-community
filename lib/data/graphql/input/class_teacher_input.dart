class ClassTeacherInput {
  final String id;
  final String teacherId;

  ClassTeacherInput({
    required this.id,
    required this.teacherId,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacher_id": teacherId,
      };
}
