import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/communities_body/community_card.dart';
import 'package:flutter/material.dart';

class UserCommunitiesList extends StatelessWidget {
  const UserCommunitiesList({
    Key? key,
    required this.communities,
  }) : super(key: key);

  final List<CommunityDto> communities;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [...communities.map((com) => CommunityCard(community: com))],
      ),
    );
  }
}
