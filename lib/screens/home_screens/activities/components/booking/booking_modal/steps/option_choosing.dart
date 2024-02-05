import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/screens/home_screens/activities/components/booking/widgets/booking_option_widget.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OptionChoosingStep extends StatelessWidget {
  const OptionChoosingStep(
      {super.key,
      required this.className,
      required this.classDate,
      required this.classBookingOptions,
      required this.onOptionSelected,
      required this.placesLeft,
      required this.currentOption,
      required this.nextStep});
  final String className;
  final DateTime classDate;
  final List<ClassBookingOptions> classBookingOptions;
  final void Function(String) onOptionSelected;
  final int placesLeft;
  final String? currentOption;
  final Function nextStep;

  @override
  Widget build(BuildContext context) {
    print("currentOption: $currentOption");
    return Column(
      children: [
        Column(children: [
          ...classBookingOptions.map((e) => Padding(
                padding: const EdgeInsets.all(8.0).copyWith(right: 20),
                child: BookOption(
                  bookingOption: e.bookingOption!,
                  value: currentOption == e.bookingOption!.id!,
                  onChanged: (_) {
                    onOptionSelected(e.bookingOption!.id!);
                  },
                ),
              )),
        ]),
        const SizedBox(height: 20),
        CustomButton(
          "Continue",
          () {
            if (currentOption != null) {
              nextStep();
            } else {
              Fluttertoast.showToast(
                  msg: "Please select an option to continue booking the class",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
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
