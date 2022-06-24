import 'package:acroworld/models/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Jam {
  String cid;
  String jid;
  String name;
  String? imgUrl;
  Object createdById;
  DateTime createdAt;
  DateTime date;
  List<UserModel> participants;
  String info;
  LatLng latLng;
  String communityId;
  String communityName;

  Jam(
      {required this.jid,
      required this.cid,
      required this.createdAt,
      required this.createdById,
      required this.participants,
      required this.date,
      required this.name,
      this.imgUrl,
      required this.info,
      required this.communityId,
      required this.communityName,
      required this.latLng});

  factory Jam.fromJson(dynamic json) {
    List participants = json["participants"];
    return Jam(
      cid: json["community_id"],
      jid: json['id'],
      participants: List<UserModel>.from(participants.map((particpant) =>
          UserModel.fromJson(particpant['user'], particpant['user']['id']))),
      date: DateTime.parse(json["date"]),
      name: json["name"],
      imgUrl: json["imgUrl"],
      createdById: json["created_by_id"],
      createdAt: DateTime.parse(json["created_at"]),
      info: json["info"],
      latLng: LatLng(json["latitude"], json["longitude"]),
      communityName: json["community"]["name"],
      communityId: json["community"]["id"],
    );
  }
}
