import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/event_model.dart';

class ClassModel {
  String? city;
  String? classPassUrl;
  String? description;
  String? id;
  String? imageUrl;
  Location? location;
  String? locationName;
  String? name;
  String? pricing;
  String? requirements;
  String? uscUrl;
  String? websiteUrl;
  List<ClassTeachers>? classTeachers;
  List<ClassLevels>? classLevels;
  num? distance;
  String? bookingEmail;
  int? maxBookingSlots;
  List<ClassBookingOptions>? classBookingOptions;
  bool? isInitiallyFavorized;

  ClassModel(
      {this.city,
      this.bookingEmail,
      this.maxBookingSlots,
      this.classBookingOptions,
      this.classPassUrl,
      this.description,
      this.id,
      this.imageUrl,
      this.location,
      this.locationName,
      this.name,
      this.pricing,
      this.isInitiallyFavorized,
      this.requirements,
      this.uscUrl,
      this.websiteUrl,
      this.classTeachers,
      this.distance,
      this.classLevels});

  ClassModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    classPassUrl = json['class_pass_url'];
    description = json['description'];
    distance = json['distance'];
    isInitiallyFavorized = json['favorites']?.isNotEmpty;
    id = json['id'];
    imageUrl = json['image_url'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    locationName = json['location_name'];
    name = json['name'];
    pricing = json['pricing'];
    requirements = json['requirements'];
    uscUrl = json['usc_url'];
    websiteUrl = json['website_url'];
    bookingEmail = json['booking_email'];
    maxBookingSlots = json['max_booking_slots'];
    if (json['class_booking_options'] != null) {
      classBookingOptions = <ClassBookingOptions>[];
      json['class_booking_options'].forEach((v) {
        classBookingOptions!.add(ClassBookingOptions.fromJson(v));
      });
    }
    if (json['class_teachers'] != null) {
      classTeachers = <ClassTeachers>[];
      json['class_teachers'].forEach((v) {
        classTeachers!.add(ClassTeachers.fromJson(v));
      });
    }
    if (json['class_levels'] != null) {
      classLevels = <ClassLevels>[];
      json['class_levels'].forEach((v) {
        classLevels!.add(ClassLevels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['class_pass_url'] = classPassUrl;
    data['description'] = description;
    data['id'] = id;
    data['image_url'] = imageUrl;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['location_name'] = locationName;
    data['name'] = name;
    data['pricing'] = pricing;
    data['requirements'] = requirements;
    data['usc_url'] = uscUrl;
    data['website_url'] = websiteUrl;
    if (classTeachers != null) {
      data['class_teachers'] = classTeachers!.map((v) => v.toJson()).toList();
    }
    if (classLevels != null) {
      data['class_levels'] = classLevels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
