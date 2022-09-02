class TeacherModel {
  String profilePicUrl;
  String name;
  int id;
  String description;
  String level;
  String city;
  int likes;
  List<String> pictureUrls;

  TeacherModel({
    required this.profilePicUrl,
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.city,
    required this.likes,
    required this.pictureUrls,
    // teaching since
    // classes
  });

  factory TeacherModel.fromJson(json) {
    return TeacherModel(
      profilePicUrl: json["profilePicUrl"],
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
