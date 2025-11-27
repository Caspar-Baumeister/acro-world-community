class TeacherStatistics {
  final int totalEvents;
  final int eventsParticipated;
  final int timesBooked;
  final double averageRating;
  final int totalReviews;

  const TeacherStatistics({
    required this.totalEvents,
    required this.eventsParticipated,
    required this.timesBooked,
    required this.averageRating,
    required this.totalReviews,
  });

  /// Create a copy of this TeacherStatistics with updated values
  TeacherStatistics copyWith({
    int? totalEvents,
    int? eventsParticipated,
    int? timesBooked,
    double? averageRating,
    int? totalReviews,
  }) {
    return TeacherStatistics(
      totalEvents: totalEvents ?? this.totalEvents,
      eventsParticipated: eventsParticipated ?? this.eventsParticipated,
      timesBooked: timesBooked ?? this.timesBooked,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  factory TeacherStatistics.fromJson(Map<String, dynamic> json) {
    return TeacherStatistics(
      totalEvents: json['totalEvents'] as int? ?? 0,
      eventsParticipated: json['eventsParticipated'] as int? ?? 0,
      timesBooked: json['timesBooked'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEvents': totalEvents,
      'eventsParticipated': eventsParticipated,
      'timesBooked': timesBooked,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  factory TeacherStatistics.empty() {
    return const TeacherStatistics(
      totalEvents: 0,
      eventsParticipated: 0,
      timesBooked: 0,
      averageRating: 0.0,
      totalReviews: 0,
    );
  }
}
