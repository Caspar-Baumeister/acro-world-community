import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EventsBody extends StatefulWidget {
  const EventsBody({Key? key}) : super(key: key);

  @override
  State<EventsBody> createState() => _EventsBodyState();
}

class _EventsBodyState extends State<EventsBody> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return const WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: 'https://kalender.digital/9290ecc26f6f5a51ddc5',
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       const CommingSoon(
  //         header: "What are events?",
  //         content:
  //             "This will soon be the place where you will be able to find all events relatet to acrobatics. From festivals, gatherings to greater jams. This will of course be orginized so that you will only see the events that are relevant for you.",
  //       ),
  //       const SizedBox(height: 10),
  //       RichText(
  //         text: TextSpan(
  //           text: 'For now check out most upcomming events ',
  //           style: DefaultTextStyle.of(context).style,
  //           children: <TextSpan>[
  //             TextSpan(
  //                 text: 'here',
  //                 style: const TextStyle(color: Colors.blue),
  //                 recognizer: TapGestureRecognizer()
  //                   ..onTap = () {
  //                     launchUrl(Uri.parse(
  //                         'https://kalender.digital/9290ecc26f6f5a51ddc5'));
  //                   }),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }
}
