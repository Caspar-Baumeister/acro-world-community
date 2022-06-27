class UserModel {
  String uid;
  String userName;

  UserModel({
    required this.uid,
    required this.userName,
  });

  factory UserModel.fromJson(dynamic json, String uid) {
    return UserModel(
      uid: uid,
      userName: json["name"],
    );
  }
}
