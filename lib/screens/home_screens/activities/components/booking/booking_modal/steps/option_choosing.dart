import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/booking_modal.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class OptionChoosingStep extends StatelessWidget {
  const OptionChoosingStep(
      {Key? key,
      required this.className,
      required this.classDate,
      required this.classBookingOptions,
      required this.onOptionSelected,
      required this.placesLeft,
      required this.currentOption,
      required this.nextStep})
      : super(key: key);
  final String className;
  final DateTime classDate;
  final List<ClassBookingOptions> classBookingOptions;
  final void Function(String) onOptionSelected;
  final int placesLeft;
  final String? currentOption;
  final Function nextStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          ...classBookingOptions
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(right: 20),
                    child: BookOption(
                      bookingOption: e.bookingOption!,
                      value: currentOption == e.bookingOption!.id!,
                      onChanged: (_) {
                        onOptionSelected(e.bookingOption!.id!);
                      },
                    ),
                  ))
              .toList(),
        ]),
        const SizedBox(height: 20),
        CustomButton(
          "Continue",
          () {
            nextStep();
          },
          width: double.infinity,
        ),
        Text(
          "$placesLeft places left",
          style: H10W4,
        )
      ],
    );
  }
}
