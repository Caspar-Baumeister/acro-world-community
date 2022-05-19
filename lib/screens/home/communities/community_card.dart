import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/chatroom/chatroom.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    Key? key,
    required this.community,
  }) : super(key: key);

  final Community community;

  @override
  Widget build(BuildContext context) {
    // String nextDate = "No current jams";
    // var now = DateTime.now();
    // final difference = community.nextJam.difference(now).inDays;
    // if (difference >= 0) {
    //   nextDate = "Next jam in ${difference.toString()} days";
    // }
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => Chatroom(
                  cId: community.id,
                  name: community.name,
                )),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(COMMUNITY_IMG_URL),
        ),
        title: Text(community.name),
        subtitle: Text(timeago.format(community.nextJam, allowFromNow: true),
            style: const TextStyle(fontWeight: FontWeight.w300)),
        trailing: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      ),
    );
  }
}
