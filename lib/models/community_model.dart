import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  String id;
  DateTime nextJam;
  Community({required this.id, required this.nextJam});

  factory Community.fromJson(String id, Timestamp timestamp) {
    return Community(id: id, nextJam: timestamp.toDate());
  }
}
