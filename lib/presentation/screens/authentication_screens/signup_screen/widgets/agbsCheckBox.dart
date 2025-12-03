import 'package:acroworld/presentation/screens/authentication_screens/signup_screen/widgets/custom_check_widget.dart';
import 'package:acroworld/utils/app_constants.dart';
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
            TextSpan(
                text: "I agree with the ",
                style: Theme.of(context).textTheme.bodyMedium),
            TextSpan(
                text: "terms and conditions.",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await customLaunch(AppConstants.agbUrl);
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
        content: Text(
            "Get newsletter-exclusive special offers and updates for our AcroYoga teachers, studios and organizers.",
            style: Theme.of(context).textTheme.bodyMedium));
  }
}
