import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/screens/home/communities/communities.dart';
import 'package:acroworld/screens/home/communities/communities_list.dart';
import 'package:acroworld/screens/home/communities/communities_search_bar.dart';
import 'package:acroworld/screens/home/communities/new_community/new_community.dart';
import 'package:flutter/material.dart';

class CommunitiesSearch extends StatefulWidget {
  const CommunitiesSearch({Key? key, required this.allCommunities})
      : super(key: key);

  final List<Community> allCommunities;

  @override
  State<CommunitiesSearch> createState() => _CommunitiesSearchState();
}

class _CommunitiesSearchState extends State<CommunitiesSearch> {
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
            Container(
              width: 60,
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, elevation: 0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewCommunity()),
                  );
                },
                child: Stack(
                  children: const <Widget>[
                    ImageIcon(
                      AssetImage("assets/add-all.png"),
                      color: Colors.black,
                    ),
                    Text(
                      'New',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
