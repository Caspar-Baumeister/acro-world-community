import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  String communityId;
  Timestamp createdAt;

  Community({
    required this.communityId,
    required this.createdAt,
  });

  factory Community.fromJson(dynamic json) {
    return Community(
      communityId: json["community_id"],
      createdAt: json["created_at"],
    );
  }
}

class UserModel {
  String uid;
  String? userName;
  String? imgUrl;
  String? bio;
  List<Community>? communities;
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
    List<Community>? communities = List<Community>.from(
        json["communities"].map((json) => Community.fromJson(json)));
    return UserModel(
      uid: uid,
      userName: json["userName"],
      imgUrl: json["imgUrl"],
      bio: json["bio"],
      communities: communities,
      lastCreatedJam: json["last_created_jam"],
      lastCreatedCommunity: json["last_created_community"],
    );
  }
}
