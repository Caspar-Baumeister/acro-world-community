import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AcronycWidget extends StatelessWidget {
  const AcronycWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "The Acronyc",
          style: H16W7,
        ),
        const SizedBox(height: 10),
        Image.asset("assets/acronyc.png"),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                  text:
                      "Our recommended book for acroyogies who want to dive deep into the technique and beauty of acroyoga. You can order the book",
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                text: " here.",
                style: const TextStyle(
                    color: LINK_COLOR, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await customLaunch("https://acronyc.de/");
                  },
              ),
              const TextSpan(
                  text: " Use the code ",
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: "ACROWORLD",
                  style: const TextStyle(color: SUCCESS_COLOR),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Clipboard.setData(const ClipboardData(text: "ACROWORLD"));
                      Fluttertoast.showToast(
                          msg:
                              "Code copied, head over to acronyc.de and add the code to your cart",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }),
              const TextSpan(
                  text: " to get a discount",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }
}
