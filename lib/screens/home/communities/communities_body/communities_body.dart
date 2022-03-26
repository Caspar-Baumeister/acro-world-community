import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/communities_body/communities_list.dart';
import 'package:acroworld/screens/home/communities/communities_body/communities_search_bar.dart';
import 'package:acroworld/screens/home/communities/communities_body/new_community_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommunitiesBody extends StatefulWidget {
  const CommunitiesBody({Key? key, required this.allCommunities})
      : super(key: key);

  final List<Community> allCommunities;

  @override
  State<CommunitiesBody> createState() => _CommunitiesBodyState();
}

class _CommunitiesBodyState extends State<CommunitiesBody> {
  late List<Community> communities;

  @override
  void initState() {
    communities = widget.allCommunities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Searchbar
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Expanded(
              child: CommunitiesSearchBar(),
            ),
            NewCommunityButton(),
          ],
        ),

        // Community List
        const Expanded(child: CommunitiesList()),
      ],
    );
  }
}
