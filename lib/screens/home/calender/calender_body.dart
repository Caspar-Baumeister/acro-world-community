import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/calender/table_event.dart';
import 'package:flutter/material.dart';

class CalenderBody extends StatelessWidget {
  const CalenderBody({Key? key, required this.userJams}) : super(key: key);

  final List<Jam> userJams;

  @override
  Widget build(BuildContext context) {
    return const TableEvents();
  }
}
