import 'package:flutter/material.dart';

class RecurringPatternModel {
  String? id;
  String? classId;
  TimeOfDay startTime;
  TimeOfDay endTime;
  DateTime? startDate;
  DateTime? endDate;
  bool? isRecurring;
  int recurringEveryXWeeks;
  int? dayOfWeek;
  DateTime? createdAt;
  bool? isEndDateFinal;

  RecurringPatternModel({
    this.id,
    this.classId,
    required this.startTime,
    required this.endTime,
    this.startDate,
    this.endDate,
    this.isRecurring,
    this.recurringEveryXWeeks = 1,
    this.dayOfWeek,
    this.createdAt,
    this.isEndDateFinal,
  });

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // Assuming seconds are always 00
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': _formatTimeOfDay(startTime),
      'end_time': _formatTimeOfDay(endTime),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_recurring': isRecurring,
      'recurring_every_x_weeks': recurringEveryXWeeks,
      'day_of_week': dayOfWeek ?? 0,
    };
  }
}


// void insertClass() async {
//   final client = GraphQLProvider.of(context).value;
//   final result = await client.mutate(
//     MutationOptions(
//       document: gql(insertClassMutation),
//       variables: {
//         'name': 'Yoga Class',
//         'description': 'A relaxing yoga class.',
//         'imageUrl': 'https://example.com/image.png',
//         'classPassUrl': 'https://example.com/pass',
//         'uscUrl': 'https://example.com/usc',
//         'websiteUrl': 'https://example.com',
//         'pricing': '10 USD',
//         'eventType': 'fitness',
//         'requirements': 'Yoga mat required',
//         'location': 'POINT(1.23456 2.34567)',
//         'locationName': 'Yoga Studio',
//         'locationCity': 'New York',
//         'locationCountry': 'USA',
//         'isClasse': true,
//         'timezone': 'America/New_York',
//         'urlSlug': 'yoga-class',
//         'maxBookingSlots': 20,
//         'createdById': 'some-uuid',
//         'classOwners': [], // Add your class owners here
//         'classBookingOptions': [], // Add your class booking options here
//         'recurringPatterns': [
//           RecurringPatternModel(
//             startTime: DateTime.now(),
//             endTime: DateTime.now().add(Duration(hours: 1)),
//             dayOfWeek: 3,
//             isRecurring: true,
//             recurringEveryXWeeks: 2,
//           ).toJson()
//         ],
//         'classTeachers': [], // Add your class teachers here
//         'classLevels': [], // Add your class levels here
//       },
//     ),
//   );

//   if (result.hasException) {
//     print(result.exception.toString());
//   } else {
//     print('Class inserted: ${result.data['insert_classes_one']['id']}');
//   }
// }



// mutation InsertClassWithTwoRecurringPatterns {
//   insert_classes_one(object: {name: "Yoga for Beginners", description: "A relaxing yoga class suitable for beginners.", image_url: "https://example.com/image.png", class_pass_url: "https://example.com/pass", usc_url: "https://example.com/usc", website_url: "https://example.com", pricing: "10 USD", event_type: Trainings, requirements: "Yoga mat required", location: {type: "Point", coordinates: [1.23456, 2.34567]}, location_name: "Yoga Studio", location_city: "New York", location_country: "USA", is_classe: true, timezone: "America/New_York", url_slug: "yoga-for-beginners", max_booking_slots: 20, recurring_patterns: {data: [{start_time: "09:00:00", end_time: "10:00:00", start_date: "2024-09-05", end_date: "2024-12-05", is_recurring: true, recurring_every_x_weeks: 2, day_of_week: 4}, {start_time: "10:00:00", end_time: "11:00:00", start_date: "2024-09-07", end_date: "2024-12-07", is_recurring: true, recurring_every_x_weeks: 1, day_of_week: 6}]}}) {
//     id
//     name
//     recurring_patterns {
//       id
//       start_time
//       end_time
//       start_date
//       end_date
//       is_recurring
//       recurring_every_x_weeks
//       day_of_week
//     }
//   }