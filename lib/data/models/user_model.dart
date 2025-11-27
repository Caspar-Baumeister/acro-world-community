import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/gender_model.dart';
import 'package:acroworld/data/models/teacher_model.dart';

class User {
  List<UserRole>? userRoles;
  String? name;
  String? id;
  String? bio;
  String? teacherId;
  String? imageUrl;
  String? fcmToken;
  GenderModel? gender;
  TeacherModel? teacherProfile;
  String? email;
  Level? level;
  bool? isEmailVerified;

  User(
      {this.userRoles,
      this.name,
      this.id,
      this.bio,
      this.teacherId,
      this.gender,
      this.email,
      this.level,
      this.imageUrl,
      this.fcmToken,
      this.teacherProfile,
      this.isEmailVerified});

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
    level = json["level"] != null ? Level.fromJson(json["level"]) : null;

    name = json['name'];
    id = json['id'];
    fcmToken = json['fcmToken'];
    email = json['email'];
    bio = json['bio'];
    teacherId = json['teacher_id'];
    teacherProfile = json['teacher_profile'] != null
        ? TeacherModel.fromJson(json['teacher_profile'])
        : null;
    imageUrl = json['image_url'];
    isEmailVerified = json['is_email_verified'];
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
