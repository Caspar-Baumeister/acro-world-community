import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/all_communities/body/new_community_card.dart';
import 'package:acroworld/screens/suggest_new_community/suggest_new_community_screen.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class AllCommunitiesList extends StatelessWidget {
  const AllCommunitiesList({
    Key? key,
    required this.communities,
  }) : super(key: key);

  final List<Community> communities;

  @override
  Widget build(BuildContext context) {
    List<Widget> communityCards =
        communities.map((com) => NewCommunityCard(community: com)).toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          if (communities.isNotEmpty)
            ...communityCards
          else
            const Text("No more communities you are not part of found"),
          const Divider(
            color: Colors.grey,
            indent: 30,
            endIndent: 30,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Can't find the community your searching for?",
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SuggestNewCommunityScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Suggest a new one",
                      style: TextStyle(color: PRIMARY_COLOR),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
