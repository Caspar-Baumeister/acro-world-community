import 'package:acroworld/models/community_messages/community_message.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Community {
  String name;
  String id;
  bool confirmed;
  LatLng latLng;
  CommunityMessage? lastMessage;
  String? lastVisitedAt;
  String? nextJamAt;

  Community({
    required this.id,
    required this.name,
    required this.confirmed,
    required this.latLng,
    this.lastMessage,
    this.lastVisitedAt,
    this.nextJamAt,
  });

  factory Community.fromJson(dynamic json,
      {String? lastVisitedAt, String? nextJamAt, dynamic messageJson}) {
    return Community(
        id: json['id'],
        name: json["name"],
        confirmed: json["confirmed"],
        latLng: LatLng(json['latitude'], json['longitude']),
        lastVisitedAt: lastVisitedAt,
        nextJamAt: nextJamAt,
        lastMessage: messageJson != null
            ? CommunityMessage.fromJson(messageJson)
            : null);
  }
}
