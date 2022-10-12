import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/jam/jams/table_event_community.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';

class JamsBody extends StatelessWidget {
  const JamsBody({required this.jams, required this.cId, Key? key})
      : super(key: key);

  final String cId;
  final List<Jam> jams;

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Jam>> kEvents = jamListToHash(jams);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          child: const Text(
              "Here you can find all the jams that take place in your favorite communities"),
        ),
        TableEventsCommunity(kEvents: kEvents, cid: cId),
      ],
    );
  }
}
