class RecurringPatternInput {
  final String id;
  final String startDate;
  final String startTime;
  final String endTime;
  final int recurringEveryXWeeks;
  final bool isRecurring;

  final String? endDate;
  final int? dayOfWeek;

  RecurringPatternInput({
    required this.id,
    required this.startDate,
    required this.startTime,
    required this.endTime,
    required this.recurringEveryXWeeks,
    required this.isRecurring,
    this.dayOfWeek,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "day_of_week": dayOfWeek ?? 0,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime,
        "end_time": endTime,
        "recurring_every_x_weeks": recurringEveryXWeeks,
        "is_recurring": isRecurring,
      };
}
