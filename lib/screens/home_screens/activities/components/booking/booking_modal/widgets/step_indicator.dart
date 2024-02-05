import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

// a widget, that shows the user where he is in the booking process
class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator(
      {super.key, required this.currentStep, required this.setStep});
  final int currentStep;
  final Function(int) setStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      // cap the width to 300
      width: MediaQuery.of(context).size.width > 300
          ? 300
          : MediaQuery.of(context).size.width,
      // round corners
      decoration: BoxDecoration(
        color: SLIGHTEST_GREY_BG,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // the first step
            GestureDetector(
              onTap: () {
                setStep(0);
              },
              child: Text(
                "Choose option",
                // the style indicates which step is the current one
                style: currentStep == 0
                    ? H12W8
                    : H12W4.copyWith(color: SLIGHTEST_GREY_TEXT),

                textAlign: TextAlign.center,
              ),
            ),
            // an arrow
            const Icon(
              Icons.arrow_forward_ios,
              color: SLIGHTEST_GREY_TEXT,
              size: 10,
            ),

            // the second step
            Text(
              "Checkout",
              // the style indicates which step is the current one
              style: currentStep == 1
                  ? H12W8
                  : H12W4.copyWith(color: SLIGHTEST_GREY_TEXT),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
