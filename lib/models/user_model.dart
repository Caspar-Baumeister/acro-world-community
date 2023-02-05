import 'package:acroworld/models/gender_model.dart';

class User {
  List<UserRole>? userRoles;
  String? name;
  String? id;
  String? bio;
  String? teacherId;
  String? imageUrl;
  GenderModel? gender;

  User(
      {this.userRoles,
      this.name,
      this.id,
      this.bio,
      this.teacherId,
      this.gender,
      this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    if (json['user_roles'] != null) {
      userRoles = <UserRole>[];
      json['user_roles'].forEach((v) {
        userRoles!.add(UserRole.fromJson(v["role"]));
      });
    }
    gender = json["acro_role"] != null
        ? GenderModel.fromJson(json["acro_role"])
        : null;
    name = json['name'];
    id = json['id'];
    bio = json['bio'];
    teacherId = json['teacher_id'];
    imageUrl = json['image_url'];
  }
}

class UserRole {
  String? id;
  String? name;

  UserRole({this.id, this.name});

  UserRole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
