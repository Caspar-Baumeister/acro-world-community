class UserModel {
  String uid;
  String userName;
  String imgUrl;
  String bio;

  UserModel({
    required this.uid,
    required this.imgUrl,
    required this.userName,
    required this.bio,
  });

  factory UserModel.fromJson(dynamic json, String uid) {
    return UserModel(
      uid: uid,
      userName: json["name"],
      imgUrl: json["image_url"] ?? "",
      bio: json["bio"] ?? "",
    );
  }
}
