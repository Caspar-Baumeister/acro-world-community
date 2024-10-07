import 'package:acroworld/data/types_and_extensions/event_type.dart';

class FCMEvent {
  EventType? eventType;
  DateTime? endDate;
  String? locationCountry;
  String? locationCity;
  String name;
  String id;
  String type;
  DateTime? startDate;

  FCMEvent({
    required this.eventType,
    required this.endDate,
    required this.locationCountry,
    required this.locationCity,
    required this.name,
    required this.id,
    required this.type,
    required this.startDate,
  });

  factory FCMEvent.fromJson(Map<String, dynamic> json) {
    return FCMEvent(
      eventType: json['event_type'] != null
          ? mapStringToEventType(json['event_type'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      locationCountry: json['location_country'],
      locationCity: json['location_city'],
      name: json['name'],
      id: json['id'],
      type: json['type'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_type': eventType,
      'endDate': endDate?.toIso8601String(),
      'location_country': locationCountry,
      'location_city': locationCity,
      'name': name,
      'id': id,
      'type': type,
      'startDate': startDate?.toIso8601String(),
    };
  }
}
