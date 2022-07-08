import 'package:acroworld/models/community_model.dart';
import 'package:acroworld/provider/user_communities.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authenticate/authenticate.dart';
import 'package:acroworld/screens/home/communities/search_bar_widget.dart';
import 'package:acroworld/screens/home/communities/user_communities/list_coms.dart';
import 'package:acroworld/screens/home/communities/user_communities/new_button.dart';
import 'package:acroworld/shared/widgets/location_search/location_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCommunitiesBody extends StatefulWidget {
  const UserCommunitiesBody({Key? key}) : super(key: key);

  @override
  State<UserCommunitiesBody> createState() => _UserCommunitiesBodyState();
}

class _UserCommunitiesBodyState extends State<UserCommunitiesBody> {
  List<Community> searchResults = [];
  String query = "";
  @override
  Widget build(BuildContext context) {
    UserCommunitiesProvider userCommunitiesProvider =
        Provider.of<UserCommunitiesProvider>(context);
    searchResults = getSearchResults(userCommunitiesProvider.userCommunities);

    return RefreshIndicator(
      onRefresh: () => loadUserCommunities(context),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LocationSearch(),
                // Searchbar
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child:
                          SearchBarWidget(onChanged: (query) => search(query)),
                    ),
                    const NewCommunityButton(),
                  ],
                ),

                // Community List
                Expanded(
                  child: UserCommunitiesList(communities: searchResults),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Community> getSearchResults(List<Community> userCommunities) {
    if (query == "") return userCommunities;
    final searchLower = query.toLowerCase();
    return List<Community>.from(userCommunities.where((Community community) {
      final name = community.name.toLowerCase();

      return name.contains(searchLower);
    }));
  }

  void search(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  Future<bool> loadUserCommunities(BuildContext context) async {
    // validates that the user is loged in and the token is valid
    bool isValidToken =
        await Provider.of<UserProvider>(context, listen: false).validToken();
    if (!isValidToken) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const Authenticate())));
      return false;
    }
    String token = Provider.of<UserProvider>(context, listen: false).token!;

    // updates the user communities in provider
    await Provider.of<UserCommunitiesProvider>(context, listen: false)
        .loadDataFromDatabase(token);
    return true;
  }
}
