import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/chatroom/chatroom.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    Key? key,
    required this.community,
  }) : super(key: key);

  final Community community;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Chatroom(cId: community.id)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(MORTY_IMG_URL),
        ),
        title: Text(community.id),
        subtitle: const Text("hier kann noch was hin",
            style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }
}
