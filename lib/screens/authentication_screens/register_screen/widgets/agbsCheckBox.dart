import 'package:acroworld/screens/authentication_screens/register_screen/widgets/check_box.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AGBCheckbox extends StatefulWidget {
  const AGBCheckbox({Key? key, required this.isAgb, required this.setAgb})
      : super(key: key);

  final bool isAgb;

  final Function(bool b) setAgb;

  @override
  State<AGBCheckbox> createState() => _AGBCheckboxState();
}

class _AGBCheckboxState extends State<AGBCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckBox(
            onTap: () => widget.setAgb(!widget.isAgb), isChecked: widget.isAgb),
        const SizedBox(width: 8),
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                  text: "I agree with the ",
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: "agbs.",
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await customLaunch(AGB_URL);
                    }),
            ],
          ),
        ),
      ],
    );
  }
}
