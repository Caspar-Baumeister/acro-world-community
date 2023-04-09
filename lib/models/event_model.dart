import 'package:acroworld/models/teacher_model.dart';

class EventModel {
  String? createdAt;
  String? createdById;
  String? endDate;
  String? eventSource;
  String? eventType;
  String? originLocationName;
  String? id;
  bool? isHighlighted;
  List<String>? links;
  Location? location;
  String? locationCity;
  String? locationCountry;
  String? locationName;
  String? mainImageUrl;
  String? originCreatorName;
  String? name;
  String? pricing;
  String? startDate;
  String? updatedAt;
  String? url;
  String? description;
  List<TeacherLinkModel>? teachers;
  List<dynamic>? userParticipants;

  EventModel(
      {this.createdAt,
      this.createdById,
      this.endDate,
      this.eventSource,
      this.eventType,
      this.id,
      this.isHighlighted,
      this.links,
      this.location,
      this.locationCity,
      this.locationCountry,
      this.locationName,
      this.originLocationName,
      this.mainImageUrl,
      this.originCreatorName,
      this.name,
      this.pricing,
      this.startDate,
      this.updatedAt,
      this.url,
      this.description,
      this.teachers,
      this.userParticipants});

  EventModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    createdById = json['created_by_id'];
    endDate = json['end_date'];
    eventSource = json['event_source'];
    eventType = json['event_type'];
    id = json['id'];
    isHighlighted = json['is_highlighted'];
    links = json['links'] != null && json['links']!.isNotEmpty
        ? json['links'].cast<String>()
        : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationCity = json['location_city'] != null
        ? json['location_city'].toString().replaceAll(RegExp(r'\s+$'), '')
        : null;
    locationCountry = json['location_country'] != null
        ? json['location_country'].toString().replaceAll(RegExp(r'\s+$'), '')
        : null;
    locationName = json['location_name'];
    originLocationName = json['origin_location_name'] != null
        ? json['origin_location_name']
            .toString()
            .replaceAll(RegExp(r'\s+'), ' ')
        : json['origin_location_name'];
    mainImageUrl = json['main_image_url'];
    originCreatorName = json['origin_creator_name'];
    name = json['name'];
    pricing = json['pricing'];
    startDate = json['start_date'];
    updatedAt = json['updated_at'];
    url = json['url'];
    description = json['description'];
    if (json['teachers'] != null) {
      teachers = <TeacherLinkModel>[];
      json['teachers'].forEach((v) {
        teachers!.add(TeacherLinkModel.fromJson(v));
      });
    }
    if (json['user_participants'] != null) {
      userParticipants = <Null>[];
      json['user_participants'].forEach((v) {
        userParticipants!.add(v);
      });
    }
  }
}

class Location {
  String? type;
  Crs? crs;
  List<double>? coordinates;

  Location({this.type, this.crs, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    crs = json['crs'] != null ? Crs.fromJson(json['crs']) : null;
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (crs != null) {
      data['crs'] = crs!.toJson();
    }
    data['coordinates'] = coordinates;
    return data;
  }
}

class Crs {
  String? type;
  Properties? properties;

  Crs({this.type, this.properties});

  Crs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Properties {
  String? name;

  Properties({this.name});

  Properties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}








// import 'package:intl/intl.dart';

// class EventModel {
//   List links;
//   String? imgUrl;
//   String? name;
//   String? description;
//   String? startDate;
//   String? endDate;
//   String? eventType;
//   String? location;
//   String? createdAt;
//   String? createdBy;

//   bool? isHighlight;
//   String? source;

//   EventModel({
//     required this.links,
//     required this.imgUrl,
//     required this.name,
//     required this.description,
//     required this.startDate,
//     required this.endDate,
//     required this.eventType,
//     required this.location,
//     required this.createdAt,
//     required this.source,
//     required this.createdBy,
//     required this.isHighlight,
//   });

//   factory EventModel.fromJson(
//     dynamic json,
//   ) {
//     DateTime? sDateTime;
//     DateTime? eDateTime;
//     if (json["startDate"] != null) {
//       try {
//         sDateTime = DateFormat('d.M.y').parse(json["startDate"]!);
//       } catch (e) {
//         print("wrong startdatetime for ${json['title'] ?? 'N/A'}");
//       }
//     }
//     if (json["endDate"] != null) {
//       try {
//         eDateTime = DateFormat('d.M.y').parse(json["endDate"]!);
//       } catch (e) {
//         print("wrong enddatetime for ${json['title'] ?? 'N/A'}");
//       }
//     }

//     return EventModel(
//       links: json['links'],
//       imgUrl: json['main_image_url'],
//       name: json['name'],
//       description: json['description'],
//       startDate: json["start_date"],
//       endDate: json['end_date'],
//       eventType: json["event_type"],
//       location: json['location_name'],
//       createdAt: json['created_at'],
//       createdBy: json['created_by'],
//       isHighlight: json['is_highlight'],
//       source: json['source'],
//     );
//   }
// }
