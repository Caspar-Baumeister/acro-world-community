import 'package:cloud_firestore/cloud_firestore.dart';

class Jam {
  String jid;
  String name;
  String imgUrl;
  String createdBy;
  Timestamp createdAt;
  Timestamp date;
  String location;
  List<String> participants;
  String info;

  Jam(
      {required this.jid,
      required this.createdAt,
      required this.createdBy,
      required this.location,
      required this.participants,
      required this.date,
      required this.name,
      required this.imgUrl,
      required this.info});

  factory Jam.fromJson(dynamic json, String jid) {
    return Jam(
        jid: jid,
        location: json["location"],
        participants:
            List<String>.from(json["participants"].map((e) => e.toString())),
        date: json["date"],
        name: json["name"],
        imgUrl: json["imgUrl"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        info: json["info"]);
  }
}
