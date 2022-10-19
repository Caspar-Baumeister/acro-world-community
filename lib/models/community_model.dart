import 'package:acroworld/models/community_messages/community_message.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Community {
  String name;
  String id;
  bool? confirmed;
  LatLng? latLng;
  CommunityMessage? lastMessage;
  String? lastVisitedAt;
  String? nextJamAt;
  dynamic distance;

  Community({
    required this.id,
    required this.name,
    required this.confirmed,
    required this.latLng,
    this.lastMessage,
    this.lastVisitedAt,
    this.nextJamAt,
    this.distance,
  });

  factory Community.fromJson(dynamic json,
      {String? lastVisitedAt, String? nextJamAt, dynamic messageJson}) {
    return Community(
        id: json['id'],
        name: json["name"],
        confirmed: json["confirmed"] ?? false,
        latLng: LatLng(json['latitude'] * 1.0, json['longitude'] * 1.0),
        lastVisitedAt: lastVisitedAt,
        nextJamAt: nextJamAt,
        distance: json["distance"],
        lastMessage: messageJson != null
            ? CommunityMessage.fromJson(messageJson)
            : null);
  }
}
