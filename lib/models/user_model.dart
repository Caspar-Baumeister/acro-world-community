class UserModel {
  String uid;
  String? userName;
  String? imgUrl;
  String? bio;

  UserModel({
    required this.uid,
    this.imgUrl,
    this.userName,
    this.bio,
  });

  factory UserModel.fromJson(dynamic json, String uid) {
    return UserModel(
      uid: uid,
      userName: json["name"],
      imgUrl: json["img"],
      bio: json["bio"],
    );
  }
}
