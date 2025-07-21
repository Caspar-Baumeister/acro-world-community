import 'package:acroworld/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({super.key});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TimeOfDay? selectedTime;
  bool use24HourTime = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            child: const Text('Open time picker'),
            onPressed: () async {
              final TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.dial,
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      timePickerTheme: TimePickerThemeData(
                        dialBackgroundColor: Colors.white,
                        dialTextColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? CustomColors.accentColor
                              : Colors.black,
                        ),
                        hourMinuteColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? CustomColors.accentColor
                              : Colors.grey[200]!,
                        ),
                        hourMinuteTextColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Colors.white
                              : Colors.black,
                        ),
                        dayPeriodColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? CustomColors.accentColor
                              : Colors.grey[200]!,
                        ),
                        dayPeriodTextColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Colors.white
                              : Colors.black,
                        ),
                        dialHandColor: CustomColors.accentColor,
                        entryModeIconColor: CustomColors.accentColor,
                        inputDecorationTheme: const InputDecorationTheme(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        hourMinuteShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.black),
                        ),
                      ),
                      textTheme: const TextTheme(
                        headlineMedium: TextStyle(
                          fontSize: 36,
                          color: Colors.black, // Adjust color if necessary
                        ),
                        bodyLarge: TextStyle(
                          fontSize: 36,
                          color: Colors.black, // Adjust color if necessary
                        ),
                      ),
                    ),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat: use24HourTime,
                      ),
                      child: child!,
                    ),
                  );
                },
              );
              setState(() {
                selectedTime = time;
              });
            },
          ),
        ),
        if (selectedTime != null)
          Text('Selected time: ${selectedTime!.format(context)}'),
      ],
    );
  }
}

void showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  required Function(TimeOfDay) setTime,
  bool use24HourTime = false,
}) async {
  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
    initialEntryMode: TimePickerEntryMode.dial,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          timePickerTheme: TimePickerThemeData(
            backgroundColor: CustomColors.backgroundColor,
            dialBackgroundColor: CustomColors.secondaryBackgroundColor,
            dialHandColor: CustomColors.accentColor,
            dialTextColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? CustomColors.whiteTextColor
                  : CustomColors.primaryTextColor,
            ),
            hourMinuteColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? CustomColors.accentColor
                  : CustomColors.secondaryBackgroundColor,
            ),
            hourMinuteTextColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
                  ? CustomColors.primaryTextColor // Use dark text when selected
                  : CustomColors.primaryTextColor,
            ),
            hourMinuteShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            dayPeriodColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? CustomColors.accentColor
                  : CustomColors.secondaryBackgroundColor,
            ),
            dayPeriodTextColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? CustomColors.whiteTextColor
                  : CustomColors.primaryTextColor,
            ),
            entryModeIconColor: CustomColors.accentColor,
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(),
              hintStyle: TextStyle(color: CustomColors.primaryTextColor),
              labelStyle: TextStyle(color: CustomColors.primaryTextColor),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.primaryTextColor,
            ),
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontSize: 36,
              color: CustomColors.primaryTextColor,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              color: CustomColors.primaryTextColor,
            ),
            // This is important for input fields
            titleMedium: TextStyle(
              fontSize: 18,
              color: CustomColors.primaryTextColor,
            ),
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: use24HourTime,
          ),
          child: child!,
        ),
      );
    },
  );

  if (selectedTime != null) {
    setTime(selectedTime);
  }
}

void showWeekdayPicker({
  required BuildContext context,
  required Function(int) onDaySelected,
}) async {
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  int? selectedDayIndex = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select a weekday'),
        content: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.6,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: weekdays.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(weekdays[index]),
                onTap: () {
                  Navigator.of(context).pop(index);
                },
              );
            },
          ),
        ),
      );
    },
  );

  if (selectedDayIndex != null) {
    onDaySelected(selectedDayIndex);
  }
}
