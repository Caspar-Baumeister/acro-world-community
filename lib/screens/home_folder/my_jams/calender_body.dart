import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/screens/home_folder/my_jams/table_event_participates.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

class CalenderBody extends StatelessWidget {
  const CalenderBody({Key? key, required this.userJams}) : super(key: key);

  final List<Jam> userJams;

  @override
  Widget build(BuildContext context) {
    return TableEventsParticipates(kEvents: jamListToHash(userJams));
  }
}
