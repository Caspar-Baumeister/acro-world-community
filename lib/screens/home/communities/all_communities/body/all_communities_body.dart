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
  //late List<Community> communities = DataClass().communities;

  @override
  Widget build(BuildContext context) {
    //UserProvider userProvider = Provider.of<UserProvider>(context);
    // communities = List<Community>.from(communities.where(
    //     (element) => !userProvider.userCommunities.contains(element.id)));
    // List<Community> otherCommunities = List<Community>.from(communities.where(
    //     (com) => !userCommunitiesProvider.userCommunityIds.contains(com.id)));

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
    // query resulting communities from database that have query in name
    // QuerySnapshot<Object?> querySnapshot =
    //     await DataBaseService(uid: userProvider.activeUser!.uid)
    //         .queryCommunities(query);
    // takes away all communities that are already in the user provider
    // List<String> userComIds = userProvider.userCommunities;
    //List<String>.from(.map((e) => e.id));

    // final relevantDocs =
    //     querySnapshot.docs.where((doc) => !userComIds.contains(doc.id));
    // creates Community models
    // List<Community> newCommunities = List<Community>.from(
    //     relevantDocs.map((doc) => Community.fromJson(doc.id, doc.data())));

    // final List<Community> communitiesResult =
    //     List<Community>.from(widget.allCommunities.where((Community community) {
    //   final name = community.name.toLowerCase();
    //   final searchLower = query.toLowerCase();

    //   return name.contains(searchLower);
    // }));

    // setState(() {
    //   communities = newCommunities;
    // });
  }
}
