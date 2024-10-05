import 'package:acroworld/data/models/user_model.dart';

class CommunityMessage {
  String? id;
  String? content;
  String? createdAt;
  User? fromUser;

  CommunityMessage({this.id, this.content, this.createdAt, this.fromUser});

  CommunityMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['created_at'];
    fromUser =
        json['from_user'] != null ? User.fromJson(json['from_user']) : null;
  }
}
