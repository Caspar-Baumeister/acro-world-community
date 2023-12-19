import 'dart:io';

import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VersionToOldPage extends StatelessWidget {
  const VersionToOldPage(
      {Key? key, required this.currentVersion, required this.minVersion})
      : super(key: key);

  final String currentVersion;
  final String minVersion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text:
                            '''The current version $currentVersion is no longer supported. Only versions from version $minVersion onwards are supported.
                                
    Please download the current version from the''',
                        style: H14W4.copyWith(color: Colors.black)),
                    TextSpan(
                      text:
                          " ${Platform.isAndroid ? "Google Playstore." : "Appstore."} ", //"hier.",
                      style: H14W4.copyWith(color: LINK_COLOR),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String link = Platform.isAndroid
                              ? PLAY_STORE_LINK
                              : IOS_STORE_LINK;
                          customLaunch(link);
                        },
                    ),
                  ]),
                ),
              ),
            ),
          ])),
    );
  }
}
