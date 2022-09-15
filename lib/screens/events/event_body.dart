import 'package:acroworld/shared/widgets/comming_soon_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsBody extends StatelessWidget {
  const EventsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CommingSoon(
          header: "What are events?",
          content:
              "This will soon be the place where you will be able to find all events relatet to acrobatics. From festivals, gatherings to greater jams. This will of course be orginized so that you will only see the events that are relevant for you.",
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: 'For now check out most upcomming events ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: 'here',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse(
                          'https://kalender.digital/9290ecc26f6f5a51ddc5'));
                    }),
            ],
          ),
        )
      ],
    );
  }
}
