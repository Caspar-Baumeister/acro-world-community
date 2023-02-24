import 'package:acroworld/components/gender_distribution_pie_from_jam_id.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/components/users/user_list.dart';
import 'package:flutter/material.dart';

// displays a lazy list with all paticipants and on top the creater with a divider
class ParticipantModal extends StatelessWidget {
  const ParticipantModal(
      {Key? key, required this.participants, required this.jamId})
      : super(key: key);

  final List<User> participants;
  final String jamId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 400,
      child: Column(
        children: [
          UserList(users: participants),
          const SizedBox(height: 20),
          GenderDistributionPieFromJamId(jamId: jamId)
        ],
      ),
    );
  }
}
