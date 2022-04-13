import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUserDto extends Serializable {
  String? userName;
  String? imgUrl;
  String? bio;
  List<UserCommunity>? communities;
  Timestamp? lastCreatedJam;
  Timestamp? lastCreatedCommunity;
  UpdateUserDto(
      {this.userName,
      this.imgUrl,
      this.bio,
      this.communities,
      this.lastCreatedCommunity,
      this.lastCreatedJam});

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    return map;
  }
}

class CreateUserDto extends Serializable {
  String userName;
  String? imgUrl;
  String? bio;
  CreateUserDto({required this.userName, this.imgUrl, this.bio});

  @override
  Map<String, dynamic> toJson() {
    return {"userName": userName, "imgUrl": imgUrl, "bio": bio};
  }
}

class UserDto {
  String uid;
  String? userName;
  String? imgUrl;
  String? bio;
  List<UserCommunity>? communities;
  Timestamp lastCreatedJam;
  Timestamp lastCreatedCommunity;

  UserDto({
    required this.uid,
    this.imgUrl,
    this.userName,
    this.bio,
    this.communities,
    required this.lastCreatedJam,
    required this.lastCreatedCommunity,
  });

  factory UserDto.fromJson(dynamic json, String uid) {
    List<UserCommunity>? communities = List<UserCommunity>.from(
        json["communities"].map((json) => UserCommunity.fromJson(json)));
    return UserDto(
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

class UserCommunity {
  String communityId;
  Timestamp createdAt;

  UserCommunity({
    required this.communityId,
    required this.createdAt,
  });

  factory UserCommunity.fromJson(dynamic json) {
    return UserCommunity(
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
  List<UserCommunity>? communities;
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
    List<UserCommunity>? communities = List<UserCommunity>.from(
        json["communities"].map((json) => UserCommunity.fromJson(json)));
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
