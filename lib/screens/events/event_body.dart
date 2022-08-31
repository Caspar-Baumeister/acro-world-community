import 'package:acroworld/shared/constants.dart';
import 'package:acroworld/shared/widgets/comming_soon_widget.dart';
import 'package:flutter/material.dart';

class EventsBody extends StatelessWidget {
  const EventsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CommingSoon(
      header: "What are events?",
      content:
          "This will soon be the place where you will be able to find all events relatet to acrobatics. From festivals, gatherings to greater jams. This will of course be orginized so that you will only see the events that are relevant for you.",
    );
  }
}
