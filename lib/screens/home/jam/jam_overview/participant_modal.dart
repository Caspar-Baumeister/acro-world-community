import 'package:flutter/material.dart';

// displays a lazy list with all paticipants and on top the creater with a divider
class ParticipantModal extends StatelessWidget {
  const ParticipantModal({Key? key, required this.participants})
      : super(key: key);

  final List<String> participants;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [...participants.map((id) => Text(id))],
        ),
      ),
    );
  }
}
