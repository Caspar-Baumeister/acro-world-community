import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrawledWarningWidget extends StatelessWidget {
  const CrawledWarningWidget(
      {super.key,
      required this.child,
      this.right = 10,
      this.top = 6,
      required this.showWarning});

  final Widget child;
  final double? right;
  final double? top;
  final bool showWarning;

  @override
  Widget build(BuildContext context) {
    return showWarning
        ? Stack(
            children: [
              child,
              Positioned(
                right: right,
                top: top,
                child: GestureDetector(
                  onTap: () => showMyDialog(context),
                  child: const Icon(
                    Icons.error,
                    color: CustomColors.errorTextColor,
                  ),
                ),
              ),
            ],
          )
        : child;
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Imported content',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'The information for this event comes from an external source and may be incorrect. We do not guarantee its correctness.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "If this is an event you are organizing and you would like to make adjustments, please contact us at ",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                      TextSpan(
                          text: "info@acroworld.de",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: CustomColors.linkTextColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Clipboard.setData(const ClipboardData(
                                  text: "info@acroworld.de"));
                              showSuccessToast(
                                "Email copied",
                              );
                            }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}