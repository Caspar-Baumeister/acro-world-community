import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/event/event_rating.dart';
import 'package:acroworld/models/event/event_type.dart';
import 'package:acroworld/models/event/pose.dart';
import 'package:acroworld/models/event/social_links.dart';
import 'package:acroworld/models/event_model.dart';

class EventTemplate {
  String? id;
  String? name;
  String? description;
  List<String>? images;
  Location? location;
  String? locationName;
  List<Pose>? requirements;
  List<SocialLink>? socialLinks;
  Level? level;
  EventType? eventType;
  List<EventRating>? ratings;

  EventTemplate({
    this.id,
    this.name,
    this.description,
    this.images,
    this.location,
    this.locationName,
    this.requirements,
    this.socialLinks,
    this.level,
    this.eventType,
    this.ratings,
  });

  EventTemplate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    eventType = json['event_type'] != null
        ? EventType.fromJson(json['event_type'])
        : null;
    locationName = json['location_name'];
    images = json['images'];

    if (json['rating'] != null) {
      ratings = <EventRating>[];
      json['rating'].forEach((v) {
        ratings!.add(EventRating.fromJson(v));
      });
    }
    if (json['social_links'] != null) {
      socialLinks = <SocialLink>[];
      json['social_links'].forEach((v) {
        socialLinks!.add(SocialLink.fromJson(v));
      });
    }
    if (json['requirements'] != null) {
      requirements = <Pose>[];
      json['requirements'].forEach((v) {
        requirements!.add(Pose.fromJson(v));
      });
    }
  }
}
