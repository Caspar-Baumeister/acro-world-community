class UserModel {
  String id;
  String userName;
  String? imageUrl;
  String? bio;

  UserModel({
    required this.id,
    required this.userName,
    this.imageUrl,
    this.bio,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'],
      userName: json["name"],
      bio: json['bio'],
      imageUrl: json['image_url'],
    );
  }
}
