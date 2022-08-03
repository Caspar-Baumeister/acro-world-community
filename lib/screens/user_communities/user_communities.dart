import 'package:acroworld/screens/home/communities/settings_drawer.dart';
import 'package:acroworld/screens/user_communities/user_communities_body.dart';
import 'package:acroworld/screens/user_communities/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class UserCommunities extends StatelessWidget {
  const UserCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarUserCommunities(),
      body: const UserCommunitiesBody(),
      endDrawer: const SettingsDrawer(),
    );
  }
}
