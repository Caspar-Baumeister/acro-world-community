class TeacherModel {
  String name;
  int id;
  String description;
  List<int> level;
  String city;
  int likes;
  List<String> pictureUrls;

  TeacherModel({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.city,
    required this.likes,
    required this.pictureUrls,
  });

  factory TeacherModel.fromJson(json) {
    return TeacherModel(
      name: json["name"],
      id: json["id"],
      description: json["description"],
      city: json["city"],
      level: json["level"],
      likes: json["likes"],
      pictureUrls: json["pictureUrls"],
    );
  }
}
