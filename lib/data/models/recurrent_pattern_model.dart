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

  RecurringPatternModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        classId = json['class_id'],
        startTime = TimeOfDay.fromDateTime(DateTime.parse(json['start_time'])),
        endTime = TimeOfDay.fromDateTime(DateTime.parse(json['end_time'])),
        startDate = json['start_date'] != null
            ? DateTime.parse(json['start_date'])
            : null,
        endDate =
            json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
        isRecurring = json['is_recurring'],
        recurringEveryXWeeks = json['recurring_every_x_weeks'],
        dayOfWeek = json['day_of_week'],
        createdAt = json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        isEndDateFinal = json['is_end_date_final'];

  RecurringPatternModel copyWith({
    String? id,
    String? classId,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRecurring,
    int? recurringEveryXWeeks,
    int? dayOfWeek,
    DateTime? createdAt,
    bool? isEndDateFinal,
  }) {
    return RecurringPatternModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringEveryXWeeks: recurringEveryXWeeks ?? this.recurringEveryXWeeks,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      createdAt: createdAt ?? this.createdAt,
      isEndDateFinal: isEndDateFinal ?? this.isEndDateFinal,
    );
  }
}
