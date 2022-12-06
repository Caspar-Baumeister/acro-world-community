import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/screens/home_screens/user_communities/widgets/community_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCommunitiesList extends StatelessWidget {
  const UserCommunitiesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserCommunitiesProvider userCommunitiesProvider =
        Provider.of<UserCommunitiesProvider>(context);
    if (userCommunitiesProvider.userCommunities.isEmpty) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'No communities joined yet. Start by clicking "Add" to join a community.',
              textAlign: TextAlign.center,
            )
          ]);
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            ...userCommunitiesProvider.userCommunities
                .map((com) => CommunityCard(community: com))
          ],
        ),
      );
    }
  }
}
