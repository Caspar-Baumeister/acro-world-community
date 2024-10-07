import 'package:acroworld/screens/authentication_screens/signup_screen/check_box/custom_check_widget.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AGBCheckbox extends StatelessWidget {
  const AGBCheckbox({super.key, required this.isAgb, required this.setAgb});

  final bool isAgb;

  final Function(bool b) setAgb;

  @override
  Widget build(BuildContext context) {
    return CustomCheckWidget(
      isChecked: isAgb,
      setChecked: setAgb,
      content: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: <TextSpan>[
            const TextSpan(
                text: "I agree with the ",
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "terms and conditions.",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await customLaunch(AGB_URL);
                  }),
          ],
        ),
      ),
    );
  }
}

class NewsletterCheckbox extends StatelessWidget {
  const NewsletterCheckbox(
      {super.key, required this.isNewsletter, required this.setNewsletter});

  final bool isNewsletter;

  final Function(bool b) setNewsletter;

  @override
  Widget build(BuildContext context) {
    return CustomCheckWidget(
        isChecked: isNewsletter,
        setChecked: setNewsletter,
        content: const Text(
            "Get newsletter-exclusive special offers and updates for our AcroYoga teachers, studios and organizers.",
            style: TextStyle(color: Colors.black)));
  }
}
