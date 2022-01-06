import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  String? cid;
  String uid;
  String userName;
  Timestamp createdAt;

  Message({
    required this.message,
    this.cid,
    required this.uid,
    required this.userName,
    required this.createdAt,
  });

  set setCid(newCid) => cid = newCid;

  factory Message.fromJson(dynamic json) {
    return Message(
        message: json["message"],
        uid: json["uid"],
        userName: json["username"],
        createdAt: json["createdAt"]);
  }
}
