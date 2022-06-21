import 'package:acroworld/models/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Jam {
  String cid;
  String jid;
  String name;
  String? imgUrl;
  Object createdBy;
  DateTime createdAt;
  DateTime date;
  List<UserModel> participants;
  String? info;
  LatLng latLng;

  Jam(
      {required this.jid,
      required this.cid,
      required this.createdAt,
      required this.createdBy,
      required this.participants,
      required this.date,
      required this.name,
      this.imgUrl,
      required this.info,
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
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        info: json["info"],
        latLng: LatLng(json["latitude"], json["longitude"]));
  }
}
