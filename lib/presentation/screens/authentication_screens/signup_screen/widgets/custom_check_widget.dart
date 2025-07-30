import 'package:acroworld/presentation/components/custom_check_box.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class CustomCheckWidget extends StatelessWidget {
  const CustomCheckWidget(
      {super.key,
      required this.isChecked,
      required this.setChecked,
      required this.content});

  final bool isChecked;
  final Function(bool) setChecked;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomCheckBox(
            onTap: () => setChecked(!isChecked), isChecked: isChecked),
        const SizedBox(width: AppDimensions.spacingSmall),
        Flexible(
            child: GestureDetector(
                onTap: () => setChecked(!isChecked), child: content))
      ],
    );
  }
}
