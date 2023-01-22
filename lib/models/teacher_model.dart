class TeacherLinkModel {
  String name;
  String id;
  String? profileImageUrl;

  TeacherLinkModel({
    required this.id,
    required this.name,
    this.profileImageUrl,
  });
  factory TeacherLinkModel.fromJson(Map json) {
    return TeacherLinkModel(
        name: json["name"],
        id: json["id"],
        profileImageUrl: json["images"]?[0]?["image"]?["url"]);
  }
}

class TeacherModel {
  String? profilePicUrl;
  String name;
  String id;
  String description;
  String locationName;
  int likes;
  List<String> pictureUrls;
  List<String> teacherLevels;
  List<String> classes;
  String createdAt;
  String userID;
  String communityID;

  TeacherModel({
    required this.profilePicUrl,
    required this.id,
    required this.name,
    required this.description,
    required this.locationName,
    required this.likes,
    required this.pictureUrls,
    required this.classes,
    required this.teacherLevels,
    required this.userID,
    required this.createdAt,
    required this.communityID,

    // teaching since
  });

  factory TeacherModel.fromJson(Map json) {
    String? profilePicUrl;
    List<String> pictureUrls = [];
    List? images = json["images"];
    if (images != null && images.isNotEmpty) {
      for (var element in images) {
        if (element["is_profile_picture"] == true) {
          profilePicUrl = element["image"]["url"];
        } else {
          pictureUrls.add(element["image"]["url"]);
        }
      }
    }

    List<String> teacherLevel = [];
    List? levels = json["teacher_levels"];
    if (levels != null && levels.isNotEmpty) {
      for (var level in levels) {
        teacherLevel.add(level["level"]["name"]);
      }
    }

    return TeacherModel(
        profilePicUrl: profilePicUrl,
        name: json["name"],
        id: json["id"],
        description: json["description"],
        locationName: json["location_name"],
        likes: json["user_likes_aggregate"]?["aggregate"]?["count"] ?? 0,
        pictureUrls: pictureUrls,
        classes: [],
        createdAt: json["created_at"],
        teacherLevels: teacherLevel,
        userID: json["user_id"],
        communityID: json["community_id"]);
  }

  @override
  String toString() {
    return "Teacher: name: $name, location: $locationName, likes: ${likes.toString()}, level: ${teacherLevels.toString()}, description: $description)";
  }
}
