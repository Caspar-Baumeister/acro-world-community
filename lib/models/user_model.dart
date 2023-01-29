class User {
  List<UserRole>? userRoles;
  String? name;
  String? id;
  String? bio;
  String? teacherId;
  String? imageUrl;

  User(
      {this.userRoles,
      this.name,
      this.id,
      this.bio,
      this.teacherId,
      this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    if (json['user_roles'] != null) {
      userRoles = <UserRole>[];
      json['user_roles'].forEach((v) {
        userRoles!.add(UserRole.fromJson(v["role"]));
      });
    }
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
