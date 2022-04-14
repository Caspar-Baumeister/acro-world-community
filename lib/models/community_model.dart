import 'package:acroworld/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityDto extends Serializable {
  String name;
  String id;
  DateTime nextJam;
  CommunityDto({required this.id, required this.nextJam, required this.name});

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  factory CommunityDto.fromJson(dynamic json) {
    return CommunityDto(
        id: json["id"], nextJam: json["next_jam"], name: json["name"]);
  }
}

class Community {
  String name;
  String id;
  DateTime nextJam;
  Community({required this.id, required this.nextJam, required this.name});

  factory Community.fromJson(String id, Timestamp timestamp, String name) {
    return Community(id: id, nextJam: timestamp.toDate(), name: name);
  }
}
