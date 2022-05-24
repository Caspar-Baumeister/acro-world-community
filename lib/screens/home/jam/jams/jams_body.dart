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
    return TableEventsCommunity(kEvents: jamListToHash(jams), cid: cId);
  }
}
