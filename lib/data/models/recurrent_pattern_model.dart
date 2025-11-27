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

  String _timeStringFromTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00'; // Assuming seconds are always 00
  }

  Map<String, dynamic> toJson() {
    final json = {
      'start_time': _timeStringFromTimeOfDay(startTime),
      'end_time': _timeStringFromTimeOfDay(endTime),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_recurring': isRecurring,
      'recurring_every_x_weeks': recurringEveryXWeeks,
      'day_of_week': dayOfWeek ?? 0,
    };
    if (id != null) json['id'] = id;

    return json;
  }

  factory RecurringPatternModel.fromJson(Map<String, dynamic> json) {
    print('🔍 RECURRING PATTERN DEBUG - JSON: $json');
    print('🔍 RECURRING PATTERN DEBUG - JSON keys: ${json.keys.toList()}');
    return RecurringPatternModel(
      id: json['id'],
      classId: json['class_id'],
      startTime: _parseTimeOfDay(json['start_time']),
      endTime: _parseTimeOfDay(json['end_time']),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      isRecurring: json['is_recurring'],
      recurringEveryXWeeks: json['recurring_every_x_weeks'] ?? 1,
      dayOfWeek: json['day_of_week'] ?? 0,
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
