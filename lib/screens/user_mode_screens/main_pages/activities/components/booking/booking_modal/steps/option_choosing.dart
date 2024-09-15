import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/models/booking_option.dart';
import 'package:acroworld/screens/user_mode_screens/main_pages/activities/components/booking/widgets/booking_option_widget.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';

class OptionChoosingStep extends StatelessWidget {
  const OptionChoosingStep(
      {super.key,
      required this.className,
      required this.classDate,
      required this.classBookingOptions,
      required this.onOptionSelected,
      required this.placesLeft,
      required this.currentOption,
      required this.nextStep,
      this.maxPlaces});
  final String className;
  final DateTime classDate;
  final List<ClassBookingOptions> classBookingOptions;
  final void Function(String) onOptionSelected;
  final num? placesLeft;
  final num? maxPlaces;
  final String? currentOption;
  final Function nextStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          ...classBookingOptions.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppPaddings.tiny),
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
        StandardButton(
          text: "Continue",
          onPressed: () {
            if (currentOption != null) {
              nextStep();
            } else {
              showErrorToast(
                "Please select an option to continue booking the class",
              );
            }
          },
          isFilled: true,
          buttonFillColor: CustomColors.accentColor,
          width: double.infinity,
        ),
        placesLeft != null && maxPlaces != null
            ? Padding(
                padding: const EdgeInsets.only(top: AppPaddings.small),
                child: Text(
                  "$placesLeft / $maxPlaces places left",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: placesLeft! <= (maxPlaces! / 2)
                          ? CustomColors.errorTextColor
                          : CustomColors.accentColor),
                ),
              )
            : Container()
      ],
    );
  }
}
