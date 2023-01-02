import 'package:acroworld/screens/authentication_screens/register_screen/widgets/check_box.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AGBCheckbox extends StatefulWidget {
  const AGBCheckbox({Key? key}) : super(key: key);

  @override
  State<AGBCheckbox> createState() => _AGBCheckboxState();
}

class _AGBCheckboxState extends State<AGBCheckbox> {
  bool isAgbs = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckBox(
            onTap: () => setState(() {
                  isAgbs = !isAgbs;
                }),
            isChecked: isAgbs),
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
                      if (!await launchUrl(AGB_URL)) {
                        throw 'Could not launch';
                      }
                    }),
            ],
          ),
        ),
      ],
    );
  }
}
