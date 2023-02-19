import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/jams/table_event_community.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

class JamsBody extends StatelessWidget {
  const JamsBody({required this.jams, required this.cId, Key? key})
      : super(key: key);

  final String cId;
  final List<Jam> jams;

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Jam>> kEvents = jamListToHash(jams);
    return TableEventsCommunity(kEvents: kEvents, cid: cId);
  }
}
