import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CrawledWarningWidget extends StatelessWidget {
  const CrawledWarningWidget(
      {Key? key, required this.child, this.right = 10, this.top = 6})
      : super(key: key);

  final Widget child;
  final double? right;
  final double? top;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: right,
          top: top,
          child: GestureDetector(
            onTap: () => showMyDialog(context),
            child: const Icon(
              Icons.error,
              color: WARNING_COLOR,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Imported content',
            style: HEADER_2_TEXT_STYLE,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'The information for this event comes from an external source and may be incorrect. We do not guarantee its correctness.',
                  style: SMALL_TEXT_STYLE,
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "If this is an event you are organizing and you would like to make adjustments, please contact us at ",
                        style: SMALL_TEXT_STYLE.copyWith(color: Colors.black),
                      ),
                      TextSpan(
                          text: "info@acroworld.de",
                          style: SMALL_TEXT_STYLE.copyWith(color: LINK_COLOR),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Clipboard.setData(const ClipboardData(
                                  text: "info@acroworld.de"));
                              Fluttertoast.showToast(
                                  msg: "Email copied",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
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