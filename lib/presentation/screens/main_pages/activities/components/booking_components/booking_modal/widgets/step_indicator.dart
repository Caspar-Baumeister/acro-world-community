import 'package:acroworld/core/utils/colors.dart';
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
        color: CustomColors.secondaryBackgroundColor,
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
                    ? Theme.of(context).textTheme.titleSmall
                    : Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: CustomColors.lightTextColor),

                textAlign: TextAlign.center,
              ),
            ),
            // an arrow
            const Icon(
              Icons.arrow_forward_ios,
              color: CustomColors.lightTextColor,
              size: 10,
            ),

            // the second step
            Text(
              "Checkout",
              // the style indicates which step is the current one
              style: currentStep == 1
                  ? Theme.of(context).textTheme.bodySmall!
                  : Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: CustomColors.lightTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
