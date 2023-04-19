import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Jam {
//   String? cid;
//   String? jid;
//   String? name;
//   String? imgUrl;
//   User? createdBy;
//   // Object createdById;
//   DateTime? createdAt;
//   DateTime? date;
//   List<User>? participants;
//   String? info;
//   LatLng? latLng;
//   Community? community;

//   Jam({
//     required this.jid,
//     required this.cid,
//     required this.createdAt,
//     // required this.createdById,
//     required this.participants,
//     required this.date,
//     required this.name,
//     required this.createdBy,
//     this.imgUrl,
//     required this.info,
//     required this.community,
//     required this.latLng,
//   });

//   Jam.fromJson(Map<String, dynamic> json) {
//     cid = json['community_id'];
//     createdAt = DateTime.parse(json["created_at"]);
//     createdBy =
//         json['created_by'] != null ? User.fromJson(json['created_by']) : null;
//     date = DateTime.parse(json["date"]);
//     jid = json['id'];
//     info = json['info'];
//     latLng = LatLng(json["latitude"], json["longitude"]);
//     name = json['name'];
//     if (json['participants'] != null) {
//       participants = <User>[];
//       json['participants'].forEach((participant) {
//         participants!.add(User.fromJson(participant["user"]));
//       });
//     }
//     community = json['community'] != null
//         ? Community.fromJson(json['community'])
//         : null;
//   }
// }

class Jam {
  String? createdAt;
  String? createdById;
  User? createdBy;
  String? date;
  String? id;
  String? info;
  double? latitude;
  double? longitude;
  String? name;
  ParticipantsAggregate? participantsAggregate;
  List<Participants>? participants;
  Community? community;

  DateTime? get dateAsDateTime => date != null ? DateTime.parse(date!) : null;
  LatLng? get latLng => latitude != null && longitude != null
      ? LatLng(latitude!, longitude!)
      : null;

  Jam(
      {this.createdAt,
      this.createdById,
      this.createdBy,
      this.date,
      this.id,
      this.info,
      this.latitude,
      this.longitude,
      this.name,
      this.participantsAggregate,
      this.participants,
      this.community});

  Jam.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    createdById = json['created_by_id'];
    createdBy =
        json['created_by'] != null ? User.fromJson(json['created_by']) : null;
    date = json['date'];
    id = json['id'];
    info = json['info'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    participantsAggregate = json['participants_aggregate'] != null
        ? ParticipantsAggregate.fromJson(json['participants_aggregate'])
        : null;
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    community = json['community'] != null
        ? Community.fromJson(json['community'])
        : null;
  }
}

class Participants {
  User? user;

  Participants({this.user});

  Participants.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}
