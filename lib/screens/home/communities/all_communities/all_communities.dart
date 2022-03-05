import 'package:acroworld/screens/home/communities/all_communities/all_communities_stream.dart';
import 'package:flutter/material.dart';

class AllCommunities extends StatelessWidget {
  const AllCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBarCommunities(),
      body: AllCommunitiesStream(),
      // endDrawer: const SettingsDrawer(),
    );
  }
}
