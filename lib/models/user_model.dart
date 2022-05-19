// class Community {
//   String communityId;
//   Timestamp createdAt;

//   Community({
//     required this.communityId,
//     required this.createdAt,
//   });

//   factory Community.fromJson(dynamic json) {
//     return Community(
//       communityId: json["community_id"],
//       createdAt: json["last_created_jam_at"],
//     );
//   }
// }

class UserModel {
  String uid;
  String? userName;
  String? imgUrl;
  String? bio;
  // List<UserCommunityModel>? communities;
  //Timestamp createdAt;
  //Timestamp lastCreatedCommunity;

  UserModel({
    required this.uid,
    this.imgUrl,
    this.userName,
    this.bio,
    // this.communities,
    //required this.createdAt,
    //required this.lastCreatedCommunity,
  });

  factory UserModel.fromJson(dynamic json, String uid) {
    return UserModel(
      uid: uid,
      userName: json["name"],
      imgUrl: json["img"],
      bio: json["bio"],
      //createdAt: json["created_at"],
      //lastCreatedCommunity: json["last_proposed_community"],
    );
  }
}
