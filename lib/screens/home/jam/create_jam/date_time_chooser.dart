import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeChooser extends StatelessWidget {
  const DateTimeChooser(
      {Key? key, required this.chosenDateTime, required this.setDateTime})
      : super(key: key);

  final DateTime chosenDateTime;
  final Function setDateTime;
  @override
  Widget build(BuildContext context) {
    String timeString = DateFormat('yyyy.MM.dd – kk:mm').format(chosenDateTime);
    return GestureDetector(
        onTap: () => _showDatePicker(context),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          // constraints: const BoxConstraints(maxWidth: 250),
          alignment: Alignment.centerLeft,
          child: Text(
            timeString,
            style: const TextStyle(color: Color(0xFFA4A4A4), fontSize: 16.0),
          ),
        ));
  }
  // return Container(
  //   constraints: const BoxConstraints(maxWidth: 250),
  //   child: TextField(
  //     onTap: () => _showDatePicker(context),
  //     readOnly: true,
  //     decoration: buildInputDecoration(
  //       labelText: chosenDateTime.toString(),
  //     ),
  //   ),
  // );

// Show the modal that contains the CupertinoDatePicker
  void _showDatePicker(ctx) {
    final date = DateTime.now();
    var _val = date;
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 500,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(70)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    height: 400,
                    child: CupertinoDatePicker(
                        //use24hFormat: true,
                        minimumDate: date,
                        maximumDate:
                            DateTime(date.year, date.month + 1, date.day),
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) => _val = val),
                  ),
                  const SizedBox(height: 6.0),
                  SizedBox(
                    width: 250.0,
                    child: CupertinoButton(
                      child: const Text('OK'),
                      onPressed: () {
                        setDateTime(_val);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  )
                ],
              ),
            ));
  }
}
