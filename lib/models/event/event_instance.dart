import 'package:acroworld/models/event/booking_object.dart';
import 'package:acroworld/models/event/event_message.dart';
import 'package:acroworld/models/event/event_template.dart';
import 'package:acroworld/models/event/price_option.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/models/user_model.dart';

class EventInstance {
  String? id;
  String? name;
  String? description;
  String? eventTemplateId;
  String? startDate;
  String? endDate;
  bool? isCancelled;
  String? earlyBirdStart;
  String? earlyBirdEnd;
  EventTemplate? eventTemplate;
  List<PriceOption>? priceOptions;
  BookingObject? bookingObject;
  List<EventMessage>? messages;
  List<User>? participants;
  List<TeacherModel>? teachers;

  EventInstance({
    this.id,
    this.name,
    this.description,
    this.eventTemplateId,
    this.startDate,
    this.endDate,
    this.priceOptions,
    this.isCancelled,
    this.earlyBirdStart,
    this.earlyBirdEnd,
    this.bookingObject,
    this.messages,
    this.participants,
    this.teachers,
    this.eventTemplate,
  });

  EventInstance.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    eventTemplateId = json["event_template_id"];
    startDate = json["start_date"];
    endDate = json["end_date"];
    isCancelled = json["is_cancelled"];
    earlyBirdStart = json["early_bird_start"];
    earlyBirdEnd = json["early_bird_end"];
    bookingObject = json['booking_object'] != null
        ? BookingObject.fromJson(json['booking_object'])
        : null;

    eventTemplate = json['event_template'] != null
        ? EventTemplate.fromJson(json['event_template'])
        : null;

    if (json['price_options'] != null) {
      priceOptions = <PriceOption>[];
      json['price_options'].forEach((v) {
        priceOptions!.add(PriceOption.fromJson(v));
      });
    }
    if (json['participants'] != null) {
      participants = <User>[];
      json['participants'].forEach((v) {
        participants!.add(User.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = <EventMessage>[];
      json['messages'].forEach((v) {
        messages!.add(EventMessage.fromJson(v));
      });
    }
    if (json['teachers'] != null) {
      teachers = <TeacherModel>[];
      json['teachers'].forEach((v) {
        teachers!.add(TeacherModel.fromJson(v));
      });
    }
  }
}
