import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  String name;
  String id;
  DateTime nextJam;
  Community({required this.id, required this.nextJam, required this.name});

  factory Community.fromJson(String id, Timestamp timestamp, String name) {
    return Community(id: id, nextJam: timestamp.toDate(), name: name);
  }
}
