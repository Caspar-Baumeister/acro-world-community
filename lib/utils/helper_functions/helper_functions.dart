import 'dart:collection';

import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

// builds the modal widgets
Future<void> buildMortal(BuildContext context, Widget mordal) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      context: context,
      builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: mordal));
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

bool isSameDate(DateTime a, DateTime b) {
  return a.day == b.day && a.month == b.month && a.year == b.year;
}

Map<DateTime, List<Jam>> jamListToHash(List<Jam> jams) {
  List<Jam> sortedJams = List<Jam>.from(jams);
  sortedJams.sort(
      (j1, j2) => j1.dateAsDateTime!.isBefore(j2.dateAsDateTime!) ? 1 : 0);
  LinkedHashMap<DateTime, List<Jam>> jamMap =
      LinkedHashMap<DateTime, List<Jam>>(
    equals: isSameDayCustom,
    hashCode: getHashCode,
  );
  for (Jam jam in sortedJams) {
    if (jamMap[jam.date] != null) {
      jamMap[jam.date]!.add(jam);
    } else {
      jamMap[jam.dateAsDateTime!] = List.from([jam]);
    }
  }
  return jamMap;

  // jamMap..addAll({
  //     for (var jam in jams)

  //     jam.date: [jam]
  //   });
}

Map<DateTime, List<ClassEvent>> classEventToHash(List objects) {
  List<ClassEvent> sortedObjects = List<ClassEvent>.from(objects);
  sortedObjects.sort((classEvent1, classEvent2) =>
      classEvent2.date.compareTo(classEvent1.date));
  LinkedHashMap<DateTime, List<ClassEvent>> objectMap =
      LinkedHashMap<DateTime, List<ClassEvent>>(
    equals: isSameDayCustom,
    hashCode: getHashCode,
  );
  for (var obj in sortedObjects) {
    if (objectMap[obj.date] != null) {
      objectMap[obj.date]!.add(obj);
    } else {
      objectMap[obj.date] = List.from([obj]);
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
  Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  if (await canLaunchUrl(googleUrl)) {
    await launchUrl(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}
