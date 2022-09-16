import 'package:flutter/material.dart';

List<Widget> dividedList(List l) {
  List<Widget> newL = [];
  for (var i = 0; i < l.length; i++) {
    newL.add(l[i]);
    if (i != l.length - 1) {
      newL.add(const Divider(
          indent: 10, endIndent: 10, thickness: 0, color: Colors.grey));
    }
  }
  return newL;
}
