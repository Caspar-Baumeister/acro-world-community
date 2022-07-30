import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/user_communities/widgets/community_card.dart';
import 'package:flutter/material.dart';

class UserCommunitiesList extends StatelessWidget {
  const UserCommunitiesList({
    Key? key,
    required this.communities,
  }) : super(key: key);

  final List<Community> communities;

  @override
  Widget build(BuildContext context) {
    if (communities.isEmpty) {
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
            ...communities.map((com) => CommunityCard(community: com))
          ],
        ),
      );
    }
  }
}
