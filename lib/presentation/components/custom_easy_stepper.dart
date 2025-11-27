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
      activeStepTextColor: Theme.of(context).colorScheme.onPrimary,
      finishedStepTextColor: Theme.of(context).colorScheme.onPrimary,
      finishedStepBorderColor: Theme.of(context).colorScheme.primary,
      activeStepBackgroundColor: Theme.of(context).colorScheme.primary,
      showLoadingAnimation: false,
      stepRadius: 12,

      showStepBorder: false,
      // map steps with the index
      steps: steps
          .map(
              (step) => buildCustomEasyStep(step, steps.indexOf(step), context))
          .toList(),
      onStepReached: (index) => onStepReached(index),
      fitWidth: true,
      internalPadding: 16,
    );
  }

  EasyStep buildCustomEasyStep(String title, int index, BuildContext context) {
    return EasyStep(
      customStep: InkWell(
        onTap: () => setStep(index),
        child: CircleAvatar(
          backgroundColor: activeStep >= index
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: activeStep == index
              ? Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary, size: 10)
              : activeStep > index
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary, size: 10)
                  : Container(),
        ),
      ),
      title: title,
      topTitle: !index.isEven,
    );
  }
}
