import 'package:acroworld/data/models/event_model.dart';

class BookmarkModel {
  String? id;
  String? createdAt;
  String? userId;
  String? eventId;
  EventModel? event;

  BookmarkModel({
    this.id,
    this.createdAt,
    this.userId,
    this.eventId,
    this.event,
  });

  BookmarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    eventId = json['event_id'];
    event = json['event'] != null ? EventModel.fromJson(json['event']) : null;
  }
}
