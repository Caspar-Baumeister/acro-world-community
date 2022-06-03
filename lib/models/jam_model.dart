import 'package:google_maps_flutter/google_maps_flutter.dart';

class Jam {
  String jid;
  String name;
  String? imgUrl;
  String createdBy;
  DateTime createdAt;
  DateTime date;
  List<String> participants;
  String? info;
  LatLng latLng;

  Jam(
      {required this.jid,
      required this.createdAt,
      required this.createdBy,
      required this.participants,
      required this.date,
      required this.name,
      this.imgUrl,
      required this.info,
      required this.latLng});

  factory Jam.fromJson(dynamic json, String jid) {
    return Jam(
        jid: jid,
        participants:
            List<String>.from(json["participants"].map((e) => e.toString())),
        date: json["date"].toDate(),
        name: json["name"],
        imgUrl: json["imgUrl"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"].toDate(),
        info: json["info"],
        latLng: LatLng(json["latlng"][0], json["latlng"][1]));
  }
}
