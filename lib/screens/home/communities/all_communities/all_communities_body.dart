import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/screens/home/communities/all_communities/all_communities_list.dart';
import 'package:acroworld/screens/home/communities/communities_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCommunitiesBody extends StatefulWidget {
  const AllCommunitiesBody({Key? key, required this.allCommunities})
      : super(key: key);

  final List<Community> allCommunities;

  @override
  State<AllCommunitiesBody> createState() => _AllCommunitiesBodyState();
}

class _AllCommunitiesBodyState extends State<AllCommunitiesBody> {
  late List<Community> communities;

  @override
  void initState() {
    communities = widget.allCommunities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserCommunitiesProvider userCommunitiesProvider =
        Provider.of<UserCommunitiesProvider>(context);

    List<Community> otherCommunities = List<Community>.from(communities.where(
        (com) => !userCommunitiesProvider.userCommunities.contains(com.id)));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Searchbar
          CommunitiesSearchBar(onChanged: (query) => search(query)),

          // Community List
          Expanded(
            child: AllCommunitiesList(communities: otherCommunities),
          )
        ],
      ),
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
