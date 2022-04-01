import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String? userName;
  String? imgUrl;
  String? bio;
  List<String>? communities;
  Timestamp lastCreatedJam;
  Timestamp lastCreatedCommunity;

  UserModel({
    required this.uid,
    this.imgUrl,
    this.userName,
    this.bio,
    this.communities,
    required this.lastCreatedJam,
    required this.lastCreatedCommunity,
  });

  factory UserModel.fromJson(dynamic json, String uid) {
    return UserModel(
      uid: uid,
      userName: json["userName"],
      imgUrl: json["imgUrl"],
      bio: json["bio"],
      communities: json["communities"],
      lastCreatedJam: json["last_created_jam"],
      lastCreatedCommunity: json["last_created_community"],
    );
  }
}
