import 'package:acroworld/provider/all_other_coms.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/home/communities/all_communities/body/all_communities_list.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCommunitiesBody extends StatefulWidget {
  const AllCommunitiesBody({Key? key}) : super(key: key);

  @override
  State<AllCommunitiesBody> createState() => _AllCommunitiesBodyState();
}

class _AllCommunitiesBodyState extends State<AllCommunitiesBody> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String token = Provider.of<UserProvider>(context, listen: false).token!;
      Provider.of<AllOtherComs>(context, listen: false)
          .loadDataFromDatabase(token, query);
    });
    super.initState();
  }

  String query = "";
  @override
  Widget build(BuildContext context) {
    AllOtherComs allOtherComs = Provider.of<AllOtherComs>(context);
    String token = Provider.of<UserProvider>(context, listen: false).token!;
    if (allOtherComs.initialized == false) {
      allOtherComs.loadDataFromDatabase(token, query);
    }

    return allOtherComs.initialized
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Searchbar
                SearchBarWidget(onChanged: (query) => search(query, token)),

                // Community List
                Expanded(
                  child: AllCommunitiesList(
                      communities: allOtherComs.allOtherComs),
                )
              ],
            ),
          )
        : const Loading();
  }

  void search(String newQuery, String token) async {
    setState(() {
      query = newQuery;
    });
    Provider.of<AllOtherComs>(context, listen: false)
        .loadDataFromDatabase(token, query);
  }
}
