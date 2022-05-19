import 'package:acroworld/screens/home/communities/all_communities/all_communities_app_bar.dart';
import 'package:acroworld/screens/home/communities/all_communities/future_all_communities.dart';
import 'package:flutter/material.dart';

class AllCommunities extends StatelessWidget {
  const AllCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        appBar: AllCommunitiesAppBar(),
        body: FutureAllCommunity() //AllCommunitiesBody(),
        // endDrawer: const SettingsDrawer(),
        );
  }
}
