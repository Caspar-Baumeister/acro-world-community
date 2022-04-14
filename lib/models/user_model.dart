import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCommunityDto {
  String communityId;
  Timestamp createdAt;

  UserCommunityDto({
    required this.communityId,
    required this.createdAt,
  });

  factory UserCommunityDto.fromJson(dynamic json) {
    return UserCommunityDto(
      communityId: json["community_id"],
      createdAt: json["created_at"],
    );
  }
}

class UpdateUserDto extends Serializable {
  String? userName;
  String? imgUrl;
  String? bio;
  List<UserCommunityDto>? communities;
  Timestamp? lastCreatedJam;
  Timestamp? lastCreatedCommunity;
  UpdateUserDto(
      {this.userName,
      this.imgUrl,
      this.bio,
      this.communities,
      this.lastCreatedCommunity,
      this.lastCreatedJam});

  Map<String, dynamic> addIfNotNull(
      String key, dynamic value, Map<String, dynamic> map) {
    if (value != null) {
      map[key] = value;
    }
    return map;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map = addIfNotNull("userName", userName, map);
    map = addIfNotNull("imgUrl", imgUrl, map);
    map = addIfNotNull("bio", bio, map);
    map = addIfNotNull("communities", communities, map);
    map = addIfNotNull("lastCreatedJam", lastCreatedJam, map);
    map = addIfNotNull("lastCreatedCommunity", lastCreatedCommunity, map);

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
  List<UserCommunityDto>? communities;
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
    List<UserCommunityDto>? communities = List<UserCommunityDto>.from(
      json["communities"].map(
        (json) => UserCommunityDto.fromJson(json),
      ),
    );
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
