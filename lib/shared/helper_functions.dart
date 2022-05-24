import 'dart:collection';

import 'package:acroworld/models/jam_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

Map<DateTime, List<Jam>> jamListToHash(List<Jam> jams) {
  // Map<DateTime, List<Jam>> jamMap = {};

  // for (Jam jam in jams) {
  //   if (jamMap[jam.date] != null) {
  //     jamMap[jam.date]!.add(jam);
  //   } else {
  //     jamMap[jam.date] = [jam];
  //   }
  // }
  // print(jamMap);
  // return jamMap;
  LinkedHashMap<DateTime, List<Jam>> jamMap =
      LinkedHashMap<DateTime, List<Jam>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  for (Jam jam in jams) {
    if (jamMap[jam.date] != null) {
      jamMap[jam.date]!.add(jam);
    } else {
      jamMap[jam.date] = [jam];
    }
  }
  return jamMap;

  // jamMap..addAll({
  //     for (var jam in jams)

  //     jam.date: [jam]
  //   });
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.year == b.year && a.month == b.month && a.day == b.day;
}
