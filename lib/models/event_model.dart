import 'package:intl/intl.dart';

class EventModel {
  List links;
  String? imgUrl;
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  String? eventType;
  String? location;
  String? createdAt;
  String? createdBy;

  bool? isHighlight;
  String? source;

  EventModel({
    required this.links,
    required this.imgUrl,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.eventType,
    required this.location,
    required this.createdAt,
    required this.source,
    required this.createdBy,
    required this.isHighlight,
  });

  factory EventModel.fromJson(
    dynamic json,
  ) {
    DateTime? sDateTime;
    DateTime? eDateTime;
    if (json["startDate"] != null) {
      try {
        sDateTime = DateFormat('d.M.y').parse(json["startDate"]!);
      } catch (e) {
        print("wrong startdatetime for ${json['title'] ?? 'N/A'}");
      }
    }
    if (json["endDate"] != null) {
      try {
        eDateTime = DateFormat('d.M.y').parse(json["endDate"]!);
      } catch (e) {
        print("wrong enddatetime for ${json['title'] ?? 'N/A'}");
      }
    }

    return EventModel(
      links: json['links'],
      imgUrl: json['main_image_url'],
      name: json['name'],
      description: json['description'],
      startDate: json["start_date"],
      endDate: json['end_date'],
      eventType: json["event_type"],
      location: json['location_name'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      isHighlight: json['is_highlight'],
      source: json['source'],
    );
  }
}
