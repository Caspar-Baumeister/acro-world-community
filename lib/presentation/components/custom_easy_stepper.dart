import 'package:acroworld/utils/colors.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class CustomEasyStepper extends StatelessWidget {
  const CustomEasyStepper(
      {super.key,
      required this.activeStep,
      required this.onStepReached,
      required this.steps,
      required this.setStep});

  final int activeStep;
  final Function(int) onStepReached;
  final List<String> steps;
  final Function(int) setStep;

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: activeStep,
      activeStepTextColor: CustomColors.primaryTextColor,
      finishedStepTextColor: CustomColors.primaryTextColor,
      finishedStepBorderColor: CustomColors.primaryTextColor,
      activeStepBackgroundColor: CustomColors.accentColor,
      showLoadingAnimation: false,
      stepRadius: 12,

      showStepBorder: false,
      // map steps with the index
      steps: steps
          .map((step) => buildCustomEasyStep(step, steps.indexOf(step)))
          .toList(),
      onStepReached: (index) => onStepReached(index),
      fitWidth: true,
      internalPadding: 16,
    );
  }

  EasyStep buildCustomEasyStep(String title, int index) {
    return EasyStep(
      customStep: InkWell(
        onTap: () => setStep(index),
        child: CircleAvatar(
          backgroundColor: activeStep >= index
              ? CustomColors.accentColor
              : CustomColors.infoBgColor,
          child: activeStep == index
              ? const Icon(Icons.edit,
                  color: CustomColors.backgroundColor, size: 10)
              : activeStep > index
                  ? const Icon(Icons.check,
                      color: CustomColors.backgroundColor, size: 10)
                  : Container(),
        ),
      ),
      title: title,
      topTitle: !index.isEven,
    );
  }
}
