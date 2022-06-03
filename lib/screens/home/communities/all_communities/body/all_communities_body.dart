import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/all_communities/body/all_communities_list.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCommunitiesBody extends StatefulWidget {
  const AllCommunitiesBody({Key? key, required this.communities})
      : super(key: key);

  final List<Community> communities;
  @override
  State<AllCommunitiesBody> createState() => _AllCommunitiesBodyState();
}

class _AllCommunitiesBodyState extends State<AllCommunitiesBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Searchbar
          SearchBarWidget(onChanged: (query) => search(query)),

          // Community List
          Expanded(
            child: AllCommunitiesList(communities: widget.communities),
          )
        ],
      ),
    );
  }

  void search(String query) async {
    UserProvider userProvider = Provider.of<UserProvider>(context);
  }
}
