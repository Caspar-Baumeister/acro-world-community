class UserModel {
  String uid;
  String? userName;
  String? imgUrl;
  String? bio;
  List<String>? communities;

  UserModel(
      {required this.uid,
      this.imgUrl,
      this.userName,
      this.bio,
      this.communities});

  factory UserModel.fromJson(dynamic json, String uid) {
    return UserModel(
        uid: uid,
        userName: json["userName"],
        imgUrl: json["imgUrl"],
        bio: json["bio"],
        communities: json["communities"]);
  }
}
