import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/communities_list.dart';
import 'package:acroworld/screens/home/communities/communities_search_bar.dart';
import 'package:acroworld/screens/home/communities/new_community_button.dart';
import 'package:flutter/material.dart';

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
          children: [
            Expanded(
                child:
                    CommunitiesSearchBar(onChanged: (query) => search(query))),
            const NewCommunityButton(),
          ],
        ),

        // Community List
        CommunitiesList(communities: communities)
      ],
    );
  }

  void search(String query) {
    final List<Community> communitiesResult =
        List<Community>.from(widget.allCommunities.where((Community community) {
      final name = community.id.toLowerCase();
      final searchLower = query.toLowerCase();

      return name.contains(searchLower);
    }));

    setState(() {
      communities = communitiesResult;
    });
  }
}
