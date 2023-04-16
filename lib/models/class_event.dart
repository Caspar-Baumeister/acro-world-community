// import 'package:acroworld/models/class_model.dart';
// import 'package:acroworld/models/teacher_model.dart';

// class ClassEvent {
//   String classId;
//   DateTime createdAt;
//   DateTime endDate;
//   String id;
//   bool isCancelled;
//   DateTime date;
//   int? countParticipants;
//   ClassModel? classModel;
//   List<TeacherLinkModel>? teacher;

//   ClassEvent(
//       {required this.classId,
//       required this.createdAt,
//       required this.endDate,
//       required this.id,
//       required this.isCancelled,
//       this.countParticipants,
//       this.classModel,
//       this.teacher,
//       required this.date});

//   factory ClassEvent.fromJson(dynamic json,
//       {ClassModel? classModel, List? teacherList}) {
//     List<TeacherLinkModel> teacher = [];

//     if (teacherList != null && teacherList.isNotEmpty) {
//       for (var t in teacherList) {
//         teacher.add(TeacherLinkModel.fromJson(t["teacher"]));
//       }
//     } else if (json["class"] != null &&
//         json["class"]["class_teachers"] != null &&
//         json["class"]["class_teachers"].isNotEmpty) {
//       for (var t in json["class"]["class_teachers"]) {
//         teacher.add(TeacherLinkModel.fromJson(t["teacher"]));
//       }
//     }

//     return ClassEvent(
//         classId: json['class_id'],
//         createdAt: DateTime.parse(json["created_at"]),
//         endDate: DateTime.parse(json["end_date"]),
//         id: json["id"],
//         countParticipants: json["participants_aggregate"]?["aggregate"]
//             ?["count"],
//         isCancelled: json["is_cancelled"],
//         classModel: classModel,
//         date: DateTime.parse(json["start_date"]),
//         teacher: teacher);
//   }
// }

import 'package:acroworld/models/teacher_model.dart';
import 'package:acroworld/models/user_model.dart';

class NewClassEventsModel {
  String? classId;
  String? createdAt;
  String? endDate;
  String? id;
  bool? isCancelled;
  String? startDate;
  ParticipantsAggregate? participantsAggregate;
  List<User>? participants;
  ClassModel? classModel;

  get date => startDate != null ? DateTime.parse(startDate!) : null;

  NewClassEventsModel(
      {this.classId,
      this.createdAt,
      this.endDate,
      this.id,
      this.isCancelled,
      this.startDate,
      this.participantsAggregate,
      this.participants,
      this.classModel});

  NewClassEventsModel.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    createdAt = json['created_at'];
    endDate = json['end_date'];
    id = json['id'];
    isCancelled = json['is_cancelled'];
    startDate = json['start_date'];
    participantsAggregate = json['participants_aggregate'] != null
        ? ParticipantsAggregate.fromJson(json['participants_aggregate'])
        : null;
    if (json['participants'] != null) {
      participants = <User>[];
      json['participants'].forEach((v) {
        participants!.add(User.fromJson(v));
      });
    }
    classModel =
        json['class'] != null ? ClassModel.fromJson(json['class']) : null;
  }
}

class ParticipantsAggregate {
  Aggregate? aggregate;

  ParticipantsAggregate({this.aggregate});

  ParticipantsAggregate.fromJson(Map<String, dynamic> json) {
    aggregate = json['aggregate'] != null
        ? Aggregate.fromJson(json['aggregate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (aggregate != null) {
      data['aggregate'] = aggregate!.toJson();
    }
    return data;
  }
}

class Aggregate {
  int? count;

  Aggregate({this.count});

  Aggregate.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

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

  ClassModel(
      {this.city,
      this.classPassUrl,
      this.description,
      this.id,
      this.imageUrl,
      this.location,
      this.locationName,
      this.name,
      this.pricing,
      this.requirements,
      this.uscUrl,
      this.websiteUrl,
      this.classTeachers,
      this.classLevels});

  ClassModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    classPassUrl = json['class_pass_url'];
    description = json['description'];
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

class ClassTeachers {
  TeacherModel? teacher;

  ClassTeachers({this.teacher});

  ClassTeachers.fromJson(Map<String, dynamic> json) {
    teacher =
        json['teacher'] != null ? TeacherModel.fromJson(json['teacher']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    }
    return data;
  }
}

class ClassLevels {
  Level? level;

  ClassLevels({this.level});

  ClassLevels.fromJson(Map<String, dynamic> json) {
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (level != null) {
      data['level'] = level!.toJson();
    }
    return data;
  }
}

class Level {
  String? name;
  String? id;

  Level({this.name, this.id});

  Level.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
