import 'package:acroworld/data/repositories/bookings_repository.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/charts/analytics_chart.dart';
import 'package:acroworld/provider/riverpod_provider/creator_provider.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for bookings analytics data
final bookingsAnalyticsProvider =
    FutureProvider.family<List<ChartDataPoint>, String>(
        (ref, timePeriod) async {
  final creatorState = ref.watch(creatorProvider);
  final creatorId = creatorState.activeTeacher?.userId;

  if (creatorId == null) {
    CustomErrorHandler.logError("Creator ID not found for analytics");
    throw Exception(
        "Creator not found. Please ensure you're logged in as a creator.");
  }

  try {
    CustomErrorHandler.logDebug(
        "Fetching bookings analytics for creator: $creatorId, period: $timePeriod");

    final repository = BookingsRepository(apiService: GraphQLClientSingleton());

    // Get date range based on time period
    final dateRange = _getDateRangeForPeriod(timePeriod);
    CustomErrorHandler.logDebug(
        "Date range: ${dateRange['start']} to ${dateRange['end']}");

    // Fetch bookings data from API
    final bookings = await repository.getCreatorsClassEventBookings(
      creatorId,
      100, // Large limit to get all data
      0,
    );

    CustomErrorHandler.logDebug("Fetched ${bookings.length} bookings");

    // Group bookings by date and create chart data points
    final result = _groupBookingsByDate(bookings, dateRange, timePeriod);
    CustomErrorHandler.logDebug(
        "Generated ${result.length} chart data points for bookings");

    return result;
  } catch (e, stackTrace) {
    CustomErrorHandler.logError("Error fetching bookings analytics: $e",
        stackTrace: stackTrace);
    rethrow;
  }
});

/// Provider for revenue analytics data
final revenueAnalyticsProvider =
    FutureProvider.family<List<ChartDataPoint>, String>(
        (ref, timePeriod) async {
  final creatorState = ref.watch(creatorProvider);
  final creatorId = creatorState.activeTeacher?.userId;

  if (creatorId == null) {
    CustomErrorHandler.logError("Creator ID not found for revenue analytics");
    throw Exception(
        "Creator not found. Please ensure you're logged in as a creator.");
  }

  try {
    CustomErrorHandler.logDebug(
        "Fetching revenue analytics for creator: $creatorId, period: $timePeriod");

    final repository = BookingsRepository(apiService: GraphQLClientSingleton());

    // Get date range based on time period
    final dateRange = _getDateRangeForPeriod(timePeriod);
    CustomErrorHandler.logDebug(
        "Date range: ${dateRange['start']} to ${dateRange['end']}");

    // Fetch bookings data from API
    final bookings = await repository.getCreatorsClassEventBookings(
      creatorId,
      100, // Large limit to get all data
      0,
    );

    CustomErrorHandler.logDebug(
        "Fetched ${bookings.length} bookings for revenue");

    // Group revenue by date and create chart data points
    final result = _groupRevenueByDate(bookings, dateRange, timePeriod);
    CustomErrorHandler.logDebug(
        "Generated ${result.length} chart data points for revenue");

    return result;
  } catch (e, stackTrace) {
    CustomErrorHandler.logError("Error fetching revenue analytics: $e",
        stackTrace: stackTrace);
    rethrow;
  }
});

/// Provider for page views analytics data (hardcoded for now)
final pageViewsAnalyticsProvider =
    FutureProvider.family<List<ChartDataPoint>, String>(
        (ref, timePeriod) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 500));

  // Generate hardcoded data based on time period
  return _generatePageViewsData(timePeriod);
});

/// Get date range for a given time period
Map<String, DateTime> _getDateRangeForPeriod(String timePeriod) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  switch (timePeriod) {
    case 'today':
      return {
        'start': today,
        'end': today.add(const Duration(days: 1)),
      };
    case 'yesterday':
      final yesterday = today.subtract(const Duration(days: 1));
      return {
        'start': yesterday,
        'end': today,
      };
    case 'last_7_days':
      return {
        'start': today.subtract(const Duration(days: 7)),
        'end': today.add(const Duration(days: 1)),
      };
    case 'last_30_days':
      return {
        'start': today.subtract(const Duration(days: 30)),
        'end': today.add(const Duration(days: 1)),
      };
    case 'this_month':
      return {
        'start': DateTime(now.year, now.month, 1),
        'end': DateTime(now.year, now.month + 1, 1),
      };
    case 'this_year':
      return {
        'start': DateTime(now.year, 1, 1),
        'end': DateTime(now.year + 1, 1, 1),
      };
    case 'all_time':
      return {
        'start': DateTime(2020, 1, 1),
        'end': today.add(const Duration(days: 1)),
      };
    default:
      return {
        'start': today.subtract(const Duration(days: 7)),
        'end': today.add(const Duration(days: 1)),
      };
  }
}

/// Group bookings by date and create chart data points
List<ChartDataPoint> _groupBookingsByDate(
  List<dynamic> bookings,
  Map<String, DateTime> dateRange,
  String timePeriod,
) {
  final Map<String, int> bookingsByDate = {};

  for (final booking in bookings) {
    final bookingDate = booking.createdAt; // Already a DateTime
    if (bookingDate.isAfter(dateRange['start']!) &&
        bookingDate.isBefore(dateRange['end']!)) {
      final dateKey = _getDateKey(bookingDate, timePeriod);
      bookingsByDate[dateKey] = (bookingsByDate[dateKey] ?? 0) + 1;
    }
  }

  return _createChartDataPoints(bookingsByDate, timePeriod);
}

/// Group revenue by date and create chart data points
List<ChartDataPoint> _groupRevenueByDate(
  List<dynamic> bookings,
  Map<String, DateTime> dateRange,
  String timePeriod,
) {
  final Map<String, double> revenueByDate = {};

  for (final booking in bookings) {
    final bookingDate = booking.createdAt; // Already a DateTime
    if (bookingDate.isAfter(dateRange['start']!) &&
        bookingDate.isBefore(dateRange['end']!)) {
      final dateKey = _getDateKey(bookingDate, timePeriod);
      final amount = booking.amount; // Already a double
      revenueByDate[dateKey] = (revenueByDate[dateKey] ?? 0.0) + amount;
    }
  }

  return _createChartDataPoints(revenueByDate, timePeriod);
}

/// Generate hardcoded page views data
List<ChartDataPoint> _generatePageViewsData(String timePeriod) {
  final now = DateTime.now();
  final data = <ChartDataPoint>[];
  
  switch (timePeriod) {
    case 'today':
      // 2-hour intervals for today (00:00 to 22:00)
      for (int hour = 0; hour <= 22; hour += 2) {
        final hourLabel = '${hour.toString().padLeft(2, '0')}:00';
        data.add(ChartDataPoint(
          label: hourLabel,
          value: 50 + (hour ~/ 2) * 10 + (hour ~/ 2) % 3 * 20,
          date: DateTime(now.year, now.month, now.day, hour),
        ));
      }
      break;
    case 'yesterday':
      // 2-hour intervals for yesterday (00:00 to 22:00)
      final yesterday = now.subtract(const Duration(days: 1));
      for (int hour = 0; hour <= 22; hour += 2) {
        final hourLabel = '${hour.toString().padLeft(2, '0')}:00';
        data.add(ChartDataPoint(
          label: hourLabel,
          value: 40 + (hour ~/ 2) * 8 + (hour ~/ 2) % 2 * 15,
          date: DateTime(yesterday.year, yesterday.month, yesterday.day, hour),
        ));
      }
      break;
    case 'last_7_days':
      // Daily data for last 7 days
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        data.add(ChartDataPoint(
          label: _getDayLabel(day),
          value: 100 + (6 - i) * 20 + (6 - i) % 3 * 50,
          date: day,
        ));
      }
      break;
    case 'last_30_days':
      // Weekly data for last 30 days
      for (int i = 4; i >= 0; i--) {
        final week = now.subtract(Duration(days: i * 7));
        data.add(ChartDataPoint(
          label: 'Week ${5 - i}',
          value: 500 + (4 - i) * 100 + (4 - i) % 2 * 200,
          date: week,
        ));
      }
      break;
    case 'this_month':
      // Daily data for this month
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      for (int i = 1; i <= daysInMonth; i++) {
        final day = DateTime(now.year, now.month, i);
        data.add(ChartDataPoint(
          label: '${day.day}',
          value: 80 + i * 5 + i % 4 * 30,
          date: day,
        ));
      }
      break;
    case 'this_year':
      // Monthly data for this year
      for (int i = 1; i <= 12; i++) {
        final month = DateTime(now.year, i, 1);
        data.add(ChartDataPoint(
          label: _getMonthName(i),
          value: 1000 + i * 200 + i % 3 * 500,
          date: month,
        ));
      }
      break;
    case 'all_time':
      // Yearly data
      for (int i = 2020; i <= now.year; i++) {
        data.add(ChartDataPoint(
          label: i.toString(),
          value: 5000 + (i - 2020) * 1000 + (i % 2) * 2000,
          date: DateTime(i, 1, 1),
        ));
      }
      break;
  }
  
  return data;
}

/// Get date key for grouping
String _getDateKey(DateTime date, String timePeriod) {
  switch (timePeriod) {
    case 'today':
    case 'yesterday':
      // Group by 2-hour intervals: 0-1:59 -> 00:00, 2-3:59 -> 02:00, etc.
      final hour = (date.hour ~/ 2) * 2;
      return '${hour.toString().padLeft(2, '0')}:00';
    case 'last_7_days':
      return _getDayLabel(date);
    case 'last_30_days':
      // Group by weeks
      final daysSinceStart = date.difference(DateTime.now().subtract(const Duration(days: 30))).inDays;
      final weekNumber = (daysSinceStart ~/ 7) + 1;
      return 'Week $weekNumber';
    case 'this_month':
      return '${date.day}';
    case 'this_year':
      return _getMonthName(date.month);
    case 'all_time':
      return date.year.toString();
    default:
      return _getDayLabel(date);
  }
}

/// Create chart data points from grouped data
List<ChartDataPoint> _createChartDataPoints(
  Map<String, dynamic> groupedData,
  String timePeriod,
) {
  final data = <ChartDataPoint>[];
  final now = DateTime.now();

  // For "today", show 2-hour intervals from 12 AM to 10 PM
  if (timePeriod == 'today') {
    for (int hour = 0; hour <= 22; hour += 2) {
      final hourLabel = '${hour.toString().padLeft(2, '0')}:00';
      final value = groupedData[hourLabel] is int
          ? groupedData[hourLabel]?.toDouble() ?? 0.0
          : groupedData[hourLabel]?.toDouble() ?? 0.0;

      data.add(ChartDataPoint(
        label: hourLabel,
        value: value,
        date: DateTime(now.year, now.month, now.day, hour),
      ));
    }
    return data;
  }

  // For "yesterday", show 2-hour intervals from 12 AM to 10 PM
  if (timePeriod == 'yesterday') {
    final yesterday = now.subtract(const Duration(days: 1));
    for (int hour = 0; hour <= 22; hour += 2) {
      final hourLabel = '${hour.toString().padLeft(2, '0')}:00';
      final value = groupedData[hourLabel] is int
          ? groupedData[hourLabel]?.toDouble() ?? 0.0
          : groupedData[hourLabel]?.toDouble() ?? 0.0;

      data.add(ChartDataPoint(
        label: hourLabel,
        value: value,
        date: DateTime(yesterday.year, yesterday.month, yesterday.day, hour),
      ));
    }
    return data;
  }

  // For "last_7_days", show all 7 days
  if (timePeriod == 'last_7_days') {
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayLabel = _getDayLabel(day);
      final value = groupedData[dayLabel] is int
          ? groupedData[dayLabel]?.toDouble() ?? 0.0
          : groupedData[dayLabel]?.toDouble() ?? 0.0;

      data.add(ChartDataPoint(
        label: dayLabel,
        value: value,
        date: day,
      ));
    }
    return data;
  }

  // For "last_30_days", show weekly intervals
  if (timePeriod == 'last_30_days') {
    for (int i = 4; i >= 0; i--) {
      final week = now.subtract(Duration(days: i * 7));
      final weekLabel = 'Week ${5 - i}';
      final value = groupedData[weekLabel] is int
          ? groupedData[weekLabel]?.toDouble() ?? 0.0
          : groupedData[weekLabel]?.toDouble() ?? 0.0;

      data.add(ChartDataPoint(
        label: weekLabel,
        value: value,
        date: week,
      ));
    }
    return data;
  }

  // For "this_month", show all days of the month
  if (timePeriod == 'this_month') {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    for (int i = 1; i <= daysInMonth; i++) {
      final dayKey = i.toString();
      final value = groupedData[dayKey] is int
          ? groupedData[dayKey]?.toDouble() ?? 0.0
          : groupedData[dayKey]?.toDouble() ?? 0.0;

      data.add(ChartDataPoint(
        label: dayKey,
        value: value,
        date: DateTime(now.year, now.month, i),
      ));
    }
    return data;
  }

  // For "this_year", show all 12 months
  if (timePeriod == 'this_year') {
    for (int i = 1; i <= 12; i++) {
      final monthName = _getMonthName(i);
      final value = groupedData[monthName] is int
          ? groupedData[monthName]?.toDouble() ?? 0.0
          : groupedData[monthName]?.toDouble() ?? 0.0;

      data.add(ChartDataPoint(
        label: monthName,
        value: value,
        date: DateTime(now.year, i, 1),
      ));
    }
    return data;
  }

  // For "all_time", show yearly intervals
  if (timePeriod == 'all_time') {
    for (int i = 2020; i <= now.year; i++) {
      final yearLabel = i.toString();
      final value = groupedData[yearLabel] is int
          ? groupedData[yearLabel]?.toDouble() ?? 0.0
          : groupedData[yearLabel]?.toDouble() ?? 0.0;

      data.add(ChartDataPoint(
        label: yearLabel,
        value: value,
        date: DateTime(i, 1, 1),
      ));
    }
    return data;
  }

  // Fallback for other time periods
  final sortedKeys = groupedData.keys.toList()..sort();

  for (final key in sortedKeys) {
    data.add(ChartDataPoint(
      label: key,
      value: groupedData[key] is int
          ? groupedData[key].toDouble()
          : groupedData[key].toDouble(),
      date: DateTime.now(),
    ));
  }

  return data;
}

/// Get day label
String _getDayLabel(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;

  if (difference == 0) return "Today";
  if (difference == 1) return "Yesterday";
  return _getWeekdayName(date.weekday);
}

/// Get weekday name
String _getWeekdayName(int weekday) {
  switch (weekday) {
    case 1:
      return "Mon";
    case 2:
      return "Tue";
    case 3:
      return "Wed";
    case 4:
      return "Thu";
    case 5:
      return "Fri";
    case 6:
      return "Sat";
    case 7:
      return "Sun";
    default:
      return "Day";
  }
}

/// Get month name
String _getMonthName(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
    default:
      return "Month";
  }
}
