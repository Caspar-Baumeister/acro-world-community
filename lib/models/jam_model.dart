import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Jam {
  String? cid;
  String? jid;
  String? name;
  String? imgUrl;
  User? createdBy;
  // Object createdById;
  DateTime? createdAt;
  DateTime? date;
  List<User>? participants;
  String? info;
  LatLng? latLng;
  Community? community;

  Jam({
    required this.jid,
    required this.cid,
    required this.createdAt,
    // required this.createdById,
    required this.participants,
    required this.date,
    required this.name,
    required this.createdBy,
    this.imgUrl,
    required this.info,
    required this.community,
    required this.latLng,
  });

  Jam.fromJson(Map<String, dynamic> json) {
    cid = json['community_id'];
    createdAt = DateTime.parse(json["created_at"]);
    createdBy =
        json['created_by'] != null ? User.fromJson(json['created_by']) : null;
    date = DateTime.parse(json["date"]);
    jid = json['id'];
    info = json['info'];
    latLng = LatLng(json["latitude"], json["longitude"]);
    name = json['name'];
    if (json['participants'] != null) {
      participants = <User>[];
      json['participants'].forEach((participant) {
        participants!.add(User.fromJson(participant["user"]));
      });
    }
    community = json['community'] != null
        ? Community.fromJson(json['community'])
        : null;
  }
}
