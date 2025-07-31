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
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).colorScheme.primary,
            onPrimary: Colors.white,
          ).copyWith(surface: Theme.of(context).colorScheme.surface),
          dialogTheme: DialogThemeData(backgroundColor: Colors.white),
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
