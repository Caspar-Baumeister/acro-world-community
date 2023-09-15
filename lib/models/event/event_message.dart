class EventMessage {
  String? id;
  String? createdAt;
  String? eventId;
  String? message;

  EventMessage({this.id, this.createdAt, this.eventId, this.message});

  EventMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    eventId = json['event_id'];
    message = json['message'];
  }
}
