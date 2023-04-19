import 'package:acroworld/models/event_model.dart';
import 'package:acroworld/screens/single_event/single_event_body.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';

class SingleEventPage extends StatelessWidget {
  const SingleEventPage({Key? key, required this.event}) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(
          event.name ?? "",
          style: HEADER_1_TEXT_STYLE.copyWith(color: Colors.black),
        ),
      ),
      body: SingleEventBody(
        event: event,
      ),
    );
  }
}
