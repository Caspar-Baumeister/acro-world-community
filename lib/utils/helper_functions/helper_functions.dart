import 'dart:collection';

import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/teacher_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> customLaunch(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

String getCurrecySymbol(String currency) {
  try {
    var format = NumberFormat.simpleCurrency(name: currency);
    return format.currencySymbol;
  } catch (e, s) {
    CustomErrorHandler.captureException(e.toString(), stackTrace: s);
    return "";
  }
}

bool isTeacherFollowedByUser(List<UserLikes>? followerList, String userId) {
  if (followerList == null) {
    return false;
  }
  for (UserLikes userLike in followerList) {
    if (userLike.userId == userId) {
      return true;
    }
  }
  return false;
}

DateTime parseDateStr(String inputString) {
  DateFormat format = DateFormat.yMMMMd();
  return format.parse(inputString);
}

String capitalizeWords(String input) {
  if (input.isEmpty) {
    return input;
  }

  List<String> words = input.toLowerCase().split(' ');

  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (word == "and") {
      words[i] = word;
    } else if (word.isNotEmpty) {
      words[i] = '${word[0].toUpperCase()}${word.substring(1)}';
    }
  }

  return words.join(' ');
}

bool isDateMonthAndYearInList(List<DateTime> dates, DateTime newDate) {
  for (DateTime date in dates) {
    if (date.month == newDate.month && date.year == newDate.year) {
      return true;
    }
  }
  return false;
}

String dateToText(DateTime date) {
  int hours = date.difference(DateTime.now()).inHours;
  int days = date.difference(DateTime.now()).inDays;

  if (days == 1) {
    return "Tommorow";
  }
  if (days == 0) {
    return "In ${hours.toString()} hours";
  }
  if (days == -1) {
    return "Yesterday";
  }
  if (days < 7 && days > 0) {
    return "Next ${DateFormat('EEEE').format(date)}";
  }
  if (days > -7 && days < 0) {
    return "Last ${DateFormat('EEEE').format(date)}";
  }
  if (days < 0) {
    return "${(days * -1).toString()} ago";
  }
  if (days > 0) {
    return "In ${days.toString()} days";
  }
  return "";
}

DateTime laterDay(DateTime a, DateTime b) {
  return a.isBefore(b) ? b : a;
}

bool isSameDate(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.day == b.day && a.month == b.month && a.year == b.year;
}

Map<DateTime, List<ClassEvent>> classEventToHash(List objects) {
  List<ClassEvent> sortedObjects = List<ClassEvent>.from(objects);
  sortedObjects.sort((classEvent1, classEvent2) =>
      classEvent2.startDateDT.compareTo(classEvent1.startDateDT));
  LinkedHashMap<DateTime, List<ClassEvent>> objectMap =
      LinkedHashMap<DateTime, List<ClassEvent>>(
    equals: isSameDayCustom,
    hashCode: getHashCode,
  );
  for (var obj in sortedObjects) {
    if (objectMap[obj.startDateDT] != null) {
      objectMap[obj.startDateDT]!.add(obj);
    } else {
      objectMap[obj.startDateDT] = List.from([obj]);
    }
  }
  return objectMap;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

bool isSameDayCustom(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = kToday; //DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 2, kToday.day);

Future<void> openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  customLaunch(googleUrl);
}
