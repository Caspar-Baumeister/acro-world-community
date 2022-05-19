import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/screens/home/communities/user_communities/list_coms.dart';
import 'package:acroworld/screens/home/communities/user_communities/new_button.dart';
import 'package:flutter/material.dart';

class UserCommunitiesBody extends StatefulWidget {
  const UserCommunitiesBody({Key? key, required this.userCommunities})
      : super(key: key);

  final List<Community> userCommunities;

  @override
  State<UserCommunitiesBody> createState() => _UserCommunitiesBodyState();
}

class _UserCommunitiesBodyState extends State<UserCommunitiesBody> {
  late List<Community> searchResults;
  late List<Community> userCommunities;

  @override
  void initState() {
    searchResults = widget.userCommunities;
    userCommunities = widget.userCommunities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userCommunities != userCommunities) {
      setState(() {
        searchResults = widget.userCommunities;
        userCommunities = widget.userCommunities;
      });
    }
    return Column(
      children: [
        // Searchbar
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SearchBarWidget(onChanged: (query) => search(query)),
            ),
            const NewCommunityButton(),
          ],
        ),

        // Community List
        Expanded(
          child: UserCommunitiesList(communities: searchResults),
        ),
      ],
    );
  }

  void search(String query) {
    final searchLower = query.toLowerCase();
    final List<Community> results = List<Community>.from(
        widget.userCommunities.where((Community community) {
      final name = community.name.toLowerCase();

      return name.contains(searchLower);
    }));

    setState(() {
      searchResults = results;
    });
  }
}
