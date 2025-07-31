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
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                        ),
                        hourMinuteColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[200]!,
                        ),
                        hourMinuteTextColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Colors.white
                              : Colors.black,
                        ),
                        dayPeriodColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[200]!,
                        ),
                        dayPeriodTextColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Colors.white
                              : Colors.black,
                        ),
                        dialHandColor: Theme.of(context).colorScheme.primary,
                        entryModeIconColor:
                            Theme.of(context).colorScheme.primary,
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            dialBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            dialHandColor: Theme.of(context).colorScheme.primary,
            dialTextColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            hourMinuteColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
            ),
            hourMinuteTextColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Theme.of(context)
                      .colorScheme
                      .onSurface // Use dark text when selected
                  : Theme.of(context).colorScheme.onSurface,
            ),
            hourMinuteShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            dayPeriodColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
            ),
            dayPeriodTextColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            entryModeIconColor: Theme.of(context).colorScheme.primary,
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(),
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          textTheme: TextTheme(
            headlineMedium: TextStyle(
              fontSize: 36,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            // This is important for input fields
            titleMedium: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
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
