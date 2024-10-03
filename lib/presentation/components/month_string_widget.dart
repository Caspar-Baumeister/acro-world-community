import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthStringWidget extends StatelessWidget {
  const MonthStringWidget({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              height: 2,
              thickness: 2,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(DateFormat.yMMMM().format(date)),
          ),
          const Expanded(
            child: Divider(
              height: 2,
              thickness: 2,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
