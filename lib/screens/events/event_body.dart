import 'package:flutter/material.dart';

class EventsBody extends StatelessWidget {
  const EventsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Center(child: Text("This is soon available")),
    );
  }
}
