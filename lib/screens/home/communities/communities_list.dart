import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/community_card.dart';
import 'package:flutter/material.dart';

class CommunitiesList extends StatelessWidget {
  const CommunitiesList({
    Key? key,
    required this.communities,
  }) : super(key: key);

  final List<Community> communities;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: communities.length,
      itemBuilder: (context, index) {
        return CommunityCard(community: communities[index]);
      },
    );
  }
}
