import 'package:acroworld/data.dart';
import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home/jam/jams/table_event_community.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';

class JamsBody extends StatelessWidget {
  JamsBody({required this.jams, required this.cId, Key? key}) : super(key: key);

  String cId;
  List<Jam> jams = DataClass().jams;

  @override
  Widget build(BuildContext context) {
    return TableEventsCommunity(kEvents: jamListToHash(jams), cid: cId);
  }
}
