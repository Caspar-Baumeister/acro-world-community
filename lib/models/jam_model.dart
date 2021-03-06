import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Jam {
  String cid;
  String jid;
  String name;
  String? imgUrl;
  UserModel createdBy;
  Object createdById;
  DateTime createdAt;
  DateTime date;
  List<UserModel> participants;
  String info;
  LatLng latLng;
  Community community;
  String communityId;
  String communityName;

  Jam({
    required this.jid,
    required this.cid,
    required this.createdAt,
    required this.createdById,
    required this.participants,
    required this.date,
    required this.name,
    required this.createdBy,
    this.imgUrl,
    required this.info,
    required this.community,
    required this.communityId,
    required this.communityName,
    required this.latLng,
  });

  factory Jam.fromJson(dynamic json) {
    List participants = json["participants"];
    return Jam(
      cid: json["community_id"],
      jid: json['id'],
      participants: List<UserModel>.from(participants
          .map((particpant) => UserModel.fromJson(particpant['user']))),
      date: DateTime.parse(json["date"]),
      name: json["name"],
      imgUrl: json["imgUrl"],
      createdById: json["created_by_id"],
      createdAt: DateTime.parse(json["created_at"]),
      info: json["info"],
      latLng: LatLng(json["latitude"], json["longitude"]),
      community: Community.fromJson(json['community']),
      communityName: json["community"]["name"],
      communityId: json["community"]["id"],
      createdBy: UserModel.fromJson(json["created_by"]),
    );
  }
}
