import 'package:flutter/material.dart';

void showDatePickerDialog({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  required Function(DateTime) setDate,
}) {
  showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          dialogBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: CustomColors.accentColor,
            onPrimary: Colors.white,
          ).copyWith(background: CustomColors.backgroundColor),
        ),
        child: child!,
      );
    },
  ).then((selectedDate) {
    if (selectedDate != null) {
      setDate(selectedDate);
    }
  });
}
