import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

class SmallStandartButtonWithLink extends StatelessWidget {
  const SmallStandartButtonWithLink(
      {super.key,
      required this.link,
      required this.text,
      this.color,
      this.customFunction});

  final String link;
  final String text;
  final Color? color;
  final Function? customFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: FilledButton(
          // set fillcolor to white
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            // set border to black and width to 1
            side: WidgetStateProperty.all<BorderSide>(
                const BorderSide(color: Colors.black, width: 1)),
          ),
          onPressed: () async {
            customFunction ?? await customLaunch(link);
          },
          child: Text(text,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: color ?? CustomColors.linkTextColor))),
    );
  }
}
