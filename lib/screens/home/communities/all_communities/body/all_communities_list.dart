import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/all_communities/body/new_community_card.dart';
import 'package:acroworld/screens/home/communities/modals/create_new_community.dart';
import 'package:acroworld/shared/helper_functions.dart';
import 'package:flutter/material.dart';

class AllCommunitiesList extends StatelessWidget {
  const AllCommunitiesList({
    Key? key,
    required this.communities,
  }) : super(key: key);

  final List<Community> communities;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...communities.map((com) => NewCommunityCard(community: com)),
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
                    onPressed: () =>
                        buildMortal(context, const CreateNewCommunityModal()),
                    child: const Text(
                      "Suggest a new one",
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
