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
