import 'package:acroworld/screens/home_folder/communities/all_communities/all_communities_app_bar.dart';
import 'package:acroworld/screens/home_folder/communities/all_communities/body/all_communities_body.dart';
import 'package:flutter/material.dart';

class AllCommunities extends StatelessWidget {
  const AllCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        appBar: AllCommunitiesAppBar(),
        body: AllCommunitiesBody());
  }
}
