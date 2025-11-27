import 'dart:io';

import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/app_constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VersionToOldPage extends StatelessWidget {
  const VersionToOldPage(
      {super.key, required this.currentVersion, required this.minVersion});

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
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingExtraLarge),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text:
                            '''The current version $currentVersion is no longer supported. Only versions from version $minVersion onwards are supported.
                                
    Please download the current version from the''',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    TextSpan(
                      text:
                          " ${Platform.isAndroid ? "Google Playstore." : "Appstore."} ", //"hier.",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
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
