import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/screens/home/communities/communities_body/community_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunitiesList extends StatelessWidget {
  const CommunitiesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserCommunitiesProvider userCommunitiesProvider =
        Provider.of<UserCommunitiesProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          ...userCommunitiesProvider.userCommunitiesSearch
              .map((com) => CommunityCard(community: com))
        ],
      ),
    );
  }
}
