import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text;
  String cid;
  String uid;
  String userName;
  Timestamp createdAt;

  Message({
    required this.text,
    required this.cid,
    required this.uid,
    required this.userName,
    required this.createdAt,
  });

  //set setCid(newCid) => cid = newCid;

  factory Message.fromJson(dynamic json, String cid) {
    return Message(
        text: json["message"],
        cid: cid,
        uid: json["uid"],
        userName: json["username"],
        createdAt: json["createdAt"]);
  }
}
